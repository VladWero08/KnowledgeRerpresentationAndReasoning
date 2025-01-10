:- ["./utils/utils.pl"].

make_new_goals(Clause, Goals, Atom, GoalsNew) :-
    eliminate(Atom, Clause, ClauseUpdated),
    merge(ClauseUpdated, Goals, GoalsNew).
    
is_clause_resolving(Clause, [Goal|Goals], GoalsNew) :-
    member(CAtom, Clause),
    is_opposite(CAtom, Goal),
    make_new_goals(Clause, Goals, CAtom, GoalsNew).

resolution_backward_helper(_, []).
resolution_backward_helper(KB, Goals) :- 
    member(Clause, KB),
    is_clause_resolving(Clause, Goals, GoalsNew),
    resolution_backward_helper(KB, GoalsNew).
resolution_backward_helper(_, _) :- false.

resolution_backward(KB, Goals) :-
    neg_list(Goals, GoalsNeg),
    resolution_backward(KB, GoalsNeg).