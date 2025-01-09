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

interval(Max, Max, [Max]).
interval(Min, Max, [Min|Rest]) :- 
    Min < Max, 
    NewMin is Min + 1,
    interval(NewMin, Max, Rest).

min(A, B, A) :- A < B, !.
min(_, B, B).

max(A, B, A) :- A > B, !.
max(_, B, B).

max_between_lists([], [], []).
max_between_lists([A|As], [], [A|Rs]) :- max_between_lists(As, [], Rs).
max_between_lists([], [B|Bs], [B|Rs]) :- max_between_lists(Bs, [], Rs).
max_between_lists([A|As], [B|Bs], [R|Rs]) :- max(A, B, R), max_between_lists(As, Bs, Rs).

sum([], 0).
sum([H|T], Sum) :- sum(T, SumRec), Sum is H + SumRec.

sum_between_lists_product([], [], 0).
sum_between_lists_product([A|As], [B|Bs], Sum) :- 
    sum_between_lists_product(As, Bs, SumRec),
    Sum is SumRec + A * B.