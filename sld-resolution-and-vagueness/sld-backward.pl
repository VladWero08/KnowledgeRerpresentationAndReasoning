:- ["./utils/utils.pl"].

make_new_goals(Clause, Goals, Atom, GoalsNew) :-
    eliminate(Atom, Clause, ClauseUpdated),
    merge(ClauseUpdated, Goals, GoalsNew).
    
is_clause_resolving(Clause, [Goal|Goals], GoalsNew) :-
    member(CAtom, Clause),
    is_opposite(CAtom, Goal),
    make_new_goals(Clause, Goals, CAtom, GoalsNew), !.

resolution_backward(_, []).
resolution_backward(KB, Goals) :- 
    member(Clause, KB),
    is_clause_resolving(Clause, Goals, GoalsNew),
    resolution_backward(KB, GoalsNew).
resolution_backward(_, _) :- false.