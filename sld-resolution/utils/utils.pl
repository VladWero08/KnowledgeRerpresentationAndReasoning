neg(n(X), X) :- !.
neg(X, n(X)).

is_neg(n(_)).
is_pos(X) :- \+ is_neg(X).
is_opposite(Atom1, Atom2) :- neg(Atom1, NAtom1), NAtom1 = Atom2.

eliminate(Target, [Target|T], T).
eliminate(Target, [H|T], [H|Result]) :- eliminate(Target, T, Result).

merge([], L, L).
merge([H|T], L, Result) :- member(H, L), !, merge(T, L, Result).
merge([H|T], L, [H|Result]) :- merge(T, L, Result).