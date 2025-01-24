:- ["./utils/utils.pl"].

get_positive_atom(Clause, Atom) :- member(Atom, Clause), is_pos(Atom), !.

make_new_goals(Clause, Goals, PAtom, NAtom, GoalsNew) :-
    eliminate(PAtom, Clause, ClauseUpdated),
    eliminate(NAtom, Goals, GoalsUpdated),
    merge(ClauseUpdated, GoalsUpdated, GoalsNew).
    
is_clause_resolving(Clause, Goals, GoalsNew) :-
    get_positive_atom(Clause, PAtom),
    member(Goal, Goals),
    is_opposite(PAtom, Goal),
    make_new_goals(Clause, Goals, PAtom, Goal, GoalsNew).

resolution_backward_helper(_, [], "YES") :- !.
resolution_backward_helper(KB, Goals, Result) :-
    member(Clause, KB),
    is_clause_resolving(Clause, Goals, GoalsNew),
    resolution_backward_helper(KB, GoalsNew, Result).
resolution_backward_helper(_, _, "NO").

resolution_backward(KB, Goals, Result) :-
    neg_list(Goals, GoalsNeg),
    resolution_backward_helper(KB, GoalsNeg, Result).