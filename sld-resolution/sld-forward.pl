:- ["./utils/utils.pl", "./utils/parse.pl", "./utils/read.pl"].

get_negative_atoms_as_positive(Clause, Atoms) :-  
    findall(NAtom, (
		member(Atom, Clause),
		is_neg(Atom),
		neg(Atom, NAtom)
	), Atoms).
    
is_clause_eligible(Clause, Solved, SolvedNew) :- 
	get_negative_atoms_as_positive(Clause, NAtoms),
    subset(NAtoms, Solved),
    get_positive_atom(Clause, PAtom),
    \+ member(PAtom, Solved),
    SolvedNew = [PAtom|Solved].

is_goal_solved([], _).
is_goal_solved([Goal|Goals], Solved) :-
    member(Goal, Solved), is_goal_solved(Goals, Solved).

resolution_forward_helper(_, Goals, Solved) :-
    is_goal_solved(Goals, Solved), !.
resolution_forward_helper(KB, Goals, Solved) :-
	member(Clause, KB), 
    is_clause_eligible(Clause, Solved, SolvedNew),
    resolution_forward_helper(KB, Goals, SolvedNew), !.
resolution_forward_helper(_, _, _) :- false.
    
resolution_forward(KB, Goals, Result) :- 
    (
        resolution_forward_helper(KB, Goals, []) ->
            Result = "YES";
            Result = "NO"
    ).