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