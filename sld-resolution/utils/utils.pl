neg(n(X), X) :- !.
neg(X, n(X)).

neg_list([], []).
neg_list([H|T], [HNeg|TNeg]) :- neg(H, HNeg), neg_list(T, TNeg).

is_neg(n(_)).
is_pos(X) :- \+ is_neg(X).
is_opposite(Atom1, Atom2) :- neg(Atom1, NAtom1), NAtom1 = Atom2.
get_positive_atom(Clause, Atom) :- member(Atom, Clause), is_pos(Atom), !.

eliminate(Target, [Target|T], T).
eliminate(Target, [H|T], [H|Result]) :- eliminate(Target, T, Result).

merge([], L, L).
merge([H|T], L, Result) :- member(H, L), !, merge(T, L, Result).
merge([H|T], L, [H|Result]) :- merge(T, L, Result).

unpack_kb([KB], KB).