/* Implementation of a SAT-Solver using the Davis-Putnam algorithm.
 * For a knowledge-base (KB) with clauses written in CNF of the form:
 * 
 * KB: list of lists 	= [[n(a), b], [a, c], [b]] 
 * Clause: list			= [n(a), b], [a, c], [b]
 * Negation: n()		= n(a) is the negation of a
 * 
 * the SAT-Solver will display YES, respectively NOT, as S is satisfiable
 * or not. In the case of YES, the procedure will also display the truth 
 * values assigned to the literals as:
 *  
 * YES						or 	NOT
 * {b/true;c/true}
 * 
 * The strategies used for selecting the literal:
 * -> literal that appears in the most clauses
 * -> literal that appears in the shortest clause 
 * */

 :- ["./utils/read.pl", "./utils/parse.pl", "./utils/utils.pl"].

/* Given a literal from the KB, eliminate all the clauses that
 * contain the literal, and remove the negation of the literal
 * from the other clauses.
 * */
eliminate_clauses_with_literal([], _, []).
eliminate_clauses_with_literal([C|KB], Literal, KBNew) :- 
    member(Literal, C), 
    eliminate_clauses_with_literal(KB, Literal, KBNew), !.
eliminate_clauses_with_literal([C|KB], Literal, [CNew|KBNew]) :- 
    neg(Literal, NegLiteral), member(NegLiteral, C), eliminate(NegLiteral, C, CNew), 
    eliminate_clauses_with_literal(KB, Literal, KBNew), !.
eliminate_clauses_with_literal([C|KB], Literal, [C|KBNew]) :- 
    eliminate_clauses_with_literal(KB, Literal, KBNew).

/* Given a literal and a clause, returns in the third variable whether 
 * the literal is part of the clause or not. 
 * */
literal_in_clause(Literal, Clause, 1) :- member(Literal, Clause).
literal_in_clause(_, _, 0).

/* Given an literal and a KB, count the number of appereances
 * of the literal in all clauses of the KB. 
 * 
 * F  = frequency
 * FR = frequency recursive 
 * */
count_literal(_, [], 0).
count_literal(Literal, [Clause|KB], F) :- literal_in_clause(Literal, Clause, LC), count_literal(Literal, KB, FR), F is LC + FR.

/* Given a literal, considering that it will be included
 * in the solution of the Davis-Putnam algorithm, extracts what
 * truth value it needs to be assigned to it.
 * */
extract_truth_literal(n(X), [X, false]).
extract_truth_literal(X, [X, true]).

/* Given a KB, extracts all the different literals into a list. */
extract_literals_from_KB(KB, Literals) :- append(KB, KBLiterals), list_to_set(KBLiterals, Literals). 

/* Given a clause, extracts the first literal from it */
extract_first_literal_from_clause([], _).
extract_first_literal_from_clause([Literal|_], Literal).

/* Given a KB and literals, extract the literal with the most of occurences. */
choose_most_frequent_literal_helper(_, [], [_, 0]).
choose_most_frequent_literal_helper(KB, [Literal|Literals], [Literal, Frequency]) :-
    count_literal(Literal, KB, Frequency),
    choose_most_frequent_literal_helper(KB, Literals, [_, CurrentMaxFrequency]),
    Frequency > CurrentMaxFrequency, !.
choose_most_frequent_literal_helper(KB, [_|Literals], [MaxLiteral, MaxFrequency]) :-
    choose_most_frequent_literal_helper(KB, Literals, [MaxLiteral, MaxFrequency]).

/* Given a KB, extracts the literal with the most occurences */
choose_most_frequent_literal(KB, Literal) :-
    extract_literals_from_KB(KB, Literals), choose_most_frequent_literal_helper(KB, Literals, [Literal, _]).

/* Given a KB, extracts the shortest clause. */
choose_shortest_clause([], [_, 2**63 - 1]).
choose_shortest_clause([Clause|KB], [Clause, ClauseLength]) :-
    length(Clause, ClauseLength),
    choose_shortest_clause(KB, [_, CurrentMinClauseLength]),
	ClauseLength < CurrentMinClauseLength, !.
choose_shortest_clause([_|KB], [MinLiteral, MinClauseLength]) :-
	choose_shortest_clause(KB, [MinLiteral, MinClauseLength]).  

/* Given a KB, extracts the first literal from the shortest clause */
choose_literal_from_shortest_clause(KB, Literal) :- choose_shortest_clause(KB, [Clause, _]), extract_first_literal_from_clause(Clause, Literal).

/* Given a KB, runs the David-Putnam SAT Solver algorithm. 
 * It returns the S solution if the algorithm succeeds.
 * */
davis_putnam([], []).
davis_putnam(KB, _) :- member([], KB), !, fail.
davis_putnam(KB, [LiteralSol|S]) :- 
    choose_literal_from_shortest_clause(KB, Literal), 
    extract_truth_literal(Literal, LiteralSol), eliminate_clauses_with_literal(KB, Literal, KBNew), 
    davis_putnam(KBNew, S), !.
davis_putnam(KB, [LiteralSol|S]) :- 
    choose_literal_from_shortest_clause(KB, Literal), neg(Literal, NegLiteral), 
    extract_truth_literal(NegLiteral, LiteralSol), eliminate_clauses_with_literal(KB, NegLiteral, KBNew), 
    davis_putnam(KBNew, S).

/* Prints the solution of the Davis-Putnam as {a/true;b/false...}*/
print_solution_helper([]).
print_solution_helper([[Literal, Truth]]) :- write(Literal), write("/"), write(Truth).
print_solution_helper([[Literal, Truth]|S]) :- write(Literal), write("/"), write(Truth), write(";"), print_solution_helper(S).
print_solution(S) :- write("{"), print_solution_helper(S), write("}").

/* Runs the Davis-Putnam algorithm and prints the result. */
sat_solve(KB) :- davis_putnam(KB, Solution), write("YES"), nl, print_solution(Solution), nl, !.
sat_solve(_) :- write("NO"), nl.

/* Runs the Davis-Putnam algorithm on multiple KBs. */
sat_solve_on_list([]).
sat_solve_on_list([KB|KBs]) :- 
    write("SAT Solver for: "), write(KB), nl,
    sat_solve(KB), nl,
    sat_solve_on_list(KBs).

/* Applies the sat solver to all KBs from a file.*/
solve :-
    read_file("./inputs/sat-solver.txt", KBs),
    process_sentences(KBs, KBParsed),
    sat_solve_on_list(KBParsed).