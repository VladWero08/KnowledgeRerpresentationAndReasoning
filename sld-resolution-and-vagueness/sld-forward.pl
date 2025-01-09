:- ["./utils/utils.pl"].

get_positive_atom(Clause, Atom) :- member(Atom, Clause), is_pos(Atom), !.
get_negative_atoms(Clause, Atoms) :-  
    findall(NAtom, (
		member(Atom, Clause),
		is_neg(Atom),
		neg(Atom, NAtom)
	), Atoms).
    
is_clause_eligible(Clause, Solved, SolvedNew) :- 
	get_negative_atoms(Clause, NAtoms),
    subset(NAtoms, Solved),
    get_positive_atom(Clause, PAtom),
    \+ member(PAtom, Solved),
    SolvedNew = [PAtom|Solved].

is_goal_solved([], _).
is_goal_solved([Goal|Goals], Solved) :-
    member(Goal, Solved), is_goal_solved(Goals, Solved).

resolution_forward_helper(_, Goals, Solved) :-
    is_goal_solved(Goals, Solved), write("YES"), !.
resolution_forward_helper(KB, Goals, Solved) :-
	member(Clause, KB), 
    is_clause_eligible(Clause, Solved, SolvedNew),
    eliminate(Clause, KB, KBNew),
    resolution_forward_helper(KBNew, Goals, SolvedNew), !.
resolution_forward_helper(_, _, _) :- write("NO").
    
resolution_forward(KB, Goals) :- resolution_forward_helper(KB, Goals, []).