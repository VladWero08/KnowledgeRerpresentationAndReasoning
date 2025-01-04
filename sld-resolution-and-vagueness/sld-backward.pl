:- ["./utils/utils.pl"].

make_new_goals(Clause, Goals, Atom, GoalsNew) :-
    eliminate(Atom, Clause, ClauseUpdated),
    neg(Atom, NAtom),
    eliminate(NAtom, Goals, GoalsUpdated),
    merge(ClauseUpdated, GoalsUpdated, GoalsNew).
    
is_clause_resolving(Clause, Goals, GoalsNew) :-
    member(CAtom, Clause),
    member(GAtom, Goals),
    is_opposite(CAtom, GAtom),
    make_new_goals(Clause, Goals, CAtom, GoalsNew), !.

resolution_backward(_, []) :- write("YES").
resolution_backward(KB, Goals) :- 
    write(Goals),
    member(Clause, KB),
    is_clause_resolving(Clause, Goals, GoalsNew),
    resolution_backward(KB, GoalsNew), !.
resolution_backward(_, _) :- write("NO"), false.