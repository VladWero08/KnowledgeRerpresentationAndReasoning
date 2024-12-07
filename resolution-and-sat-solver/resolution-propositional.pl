:- ["./read.pl", "./parse.pl"].

/* Negation of a predicate. */
neg(n(X), X) :- !.
neg(X, n(X)).

/* Check whether the given list is member of a 
 * list of lists, not taking into consideration 
 * the order of the predicates.
 * */
is_member(_, []) :- !, false.
is_member(X, [H|_]) :-
    permutation(X, H), !.
is_member(X, [_|T]) :-
    is_member(X, T).

is_not_member(X, List) :- \+ is_member(X, List).

 /* Given an element and a list, eliminates the first appearence
  * of the element from the list.
  * */
eliminate(Target, [Target|T], T).
eliminate(Target, [H|T], [H|Result]) :- eliminate(Target, T, Result).

/* Given two lists, merges them and removes any duplicates.
 * */
merge([], L, L).
merge([H|T], L, Result) :- member(H, L), !, merge(T, L, Result).
merge([H|T], L, [H|Result]) :- merge(T, L, Result).

/* Given a clause, returns whether the clause 
 * is a tautology or not.
 * */
is_tautology([]) :- false.
is_tautology([H|T]) :- neg(H, Hneg), member(Hneg, T), !.
is_tautology([_|T]) :- is_tautology(T).

/* 
 * Given a knowledge base, removes every tautology from it.
 * */
remove_tautologies([], []).
remove_tautologies([Clause|KB], KBNew) :- is_tautology(Clause), remove_tautologies(KB, KBNew).
remove_tautologies([Clause|KB], [Clause|KBNew]) :- remove_tautologies(KB, KBNew).

/* Given two clauses and a literal, removes the literal
 * from the first clause and the negated literal from
 * the second clause, then concatenates the results.
 *
 * NOTE: it is assumed that the Literal will certainly 
 * lead to a Resolvent for the given clauses.     
 * */
make_resolvent(Clause1, Clause2, Literal, Resolvent) :-
    eliminate(Literal, Clause1, Clause1New),	% eliminate literal from the first clause
    neg(Literal, LiteralNeg),
    eliminate(LiteralNeg, Clause2, Clause2New),	% eliminate negated literal from the second clause
    merge(Clause1New, Clause2New, Resolvent).   % merge the newly resulted clauses 

/* Given two clauses, searches for a literal
 * that could generate a resolvent for them.
 * */
do_resolve([], _, []).
do_resolve([H1|T1], Clause, Literal) :- 
    neg(H1, H2), member(H2, Clause), Literal = H1, !; 
    do_resolve(T1, Clause, Literal).

/* Given a knowledge base and a clause, search for another
 * clause in the knowledge base that could make a resolvent
 * with the given clause.
 * */
search_matching_clause([], [], [], [], [], []).
search_matching_clause([Clause|KB], KBOriginal, Resoluted, TargetClause, Matching, Resolvent) :- 
    is_not_member([TargetClause, Clause], Resoluted),
    do_resolve(TargetClause, Clause, Literal), Literal \= [], 
    make_resolvent(TargetClause, Clause, Literal, Resolvent), is_not_member(Resolvent, KBOriginal),
    Matching = Clause, !;
    search_matching_clause(KB, KBOriginal, Resoluted, TargetClause, Matching, Resolvent).
 
/* Given a knowledge base, searches for two clauses
 * that might form a resolvent.
 * 
 * Clause 1 is compared with Clause 2, Clause 3, Clause 4, ..., Clause n.
 * Clause 2 is compared with --------, Clause 3, Clause 4, ..., Clause n.
 * Clause 3 is compared with --------, --------, Clause 4, ..., Clause n.
 * */
search_clauses([], [], [], [], [], []).
search_clauses([Clause|KB], KBOriginal, Resoluted, Clause, Matching, Resolvent) :- 
    search_matching_clause(KB, KBOriginal, Resoluted, Clause, Matching, Resolvent), Matching \= [], !.
search_clauses([_|KB], KBOriginal, Resoluted, Clause, Matching, Resolvent) :-
    search_clauses(KB, KBOriginal, Resoluted, Clause, Matching, Resolvent).

/* Given a list of lists, where negation of predicates as 
 * denoted as n(X), applies the resolution algorithm to see 
 * if the predicates are unsatisfiable or satisfiable.
 * */
resolution_helper(KB, _) :- 
    member([], KB), write("UNSATISFIABLE"), !.
resolution_helper(KB, Resoluted) :- 
    remove_tautologies(KB, KBOpt),
    search_clauses(KBOpt, KBOpt, Resoluted, Clause, Matching, Resolvent), 
    Clause \= [], Matching \= [],
    resolution_helper([Resolvent|KBOpt], [[Clause, Matching]|Resoluted]), !.
resolution_helper(_, _) :- write("SATISFIABLE").
resolution(KB) :- resolution_helper(KB, []).

/* Given a list of KBs, apply the resolution
 * algorithm on every single KB.
 * */
resolution_on_list([]).
resolution_on_list([KB|KBs]) :-
    write("Resolution for:"), nl,
    write(KB), nl, 
    resolution(KB), nl, nl,
    resolution_on_list(KBs).

/* Applies resolution to all KBs from a file.*/
solve :-
    read_file("./inputs/resolution-propositional.txt", KBs),
    process_sentences(KBs, KBParsed),
    resolution_on_list(KBParsed).