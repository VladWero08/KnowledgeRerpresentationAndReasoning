/* Negation of a predicate. */
neg(n(X), X) :- !.
neg(X, n(X)).

/* Check whether the given list is member of a 
 * list of lists, not taking into consideration 
 * the order of the predicates.
 * */
is_member(_, []) :- !, false.
is_member(X, [H|_]) :-
    permutation(X, H), !.
is_member(X, [_|T]) :-
    is_member(X, T).

is_not_member(X, List) :- \+ is_member(X, List).

/* Given an element and a list, eliminates the first appearence
 * of the element from the list.
 * */
eliminate(Target, [Target|T], T).
eliminate(Target, [H|T], [H|Result]) :- eliminate(Target, T, Result).

/* Given two lists, merges them and removes any duplicates.
 * */
merge([], L, L).
merge([H|T], L, Result) :- member(H, L), !, merge(T, L, Result).
merge([H|T], L, [H|Result]) :- merge(T, L, Result).

/* Given a list of KBs that only contains one KB,
 * unpack the single KB from the list.
 * */
unpack_kb([KB], KB).