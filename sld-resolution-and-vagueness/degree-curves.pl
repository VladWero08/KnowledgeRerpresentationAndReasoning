min(A, B, A) :- A < B, !.
min(_, B, B).

max(A, B, A) :- A > B, !.
max(_, B, B).

poor(X, Degree) :- X >= 0, X =< 4, Degree is (1 - X * (1 / 4)).
poor(X, Degree) :- X > 4, X =< 10, Degree is 0.

good(X, Degree) :- X >= 0, X =< 2, Degree is 0.
good(X, Degree) :- X > 2, X =< 5, Degree is ((X - 2) * (1 / 3)).
good(X, Degree) :- X > 5, X =< 7, Degree is 1.
good(X, Degree) :- X > 7, X =< 8, Degree is (8 - X).
good(X, Degree) :- X >= 8, X =< 10, Degree is 0.

excellent(X, Degree) :- X >= 0, X =< 7, Degree is 0.
excellent(X, Degree) :- X > 7, X =< 10, Degree is ((X - 7) * (1 / 3)).

rancid(X, Degree) :- X >= 0, X =< 3, Degree is 1.
rancid(X, Degree) :- X > 3, X =< 6, Degree is (1 + (X - 3) * (-1 / 3)).
rancid(X, Degree) :- X > 6, X =< 10, Degree is 0.

delicious(X, Degree) :- X >= 0, X =< 6, Degree is 0.
delicious(X, Degree) :- X > 6, X =< 9, Degree is ((X - 6) * (1 / 3)).
delicious(X, Degree) :- X > 9, X =< 10, Degree is 1.

cheap(X, Degree) :- X >= 0, X =< 1, Degree is 1.
cheap(X, Degree) :- X > 1, X =< 4, Degree is (1 + (X - 1) * (-1 / 3)).
cheap(X, Degree) :- X > 4, X =< 10, Degree is 0.

normal(X, Degree) :- X >= 0, X =< 4, Degree is 0.
normal(X, Degree) :- X > 4, X =< 6, Degree is ((X - 4) * (1 / 2)).
normal(X, Degree) :- X > 6, X =< 8, Degree is (1 + (X - 6) * (-1 / 2)).
normal(X, Degree) :- X > 8, X =< 10, Degree is 0.

generous(X, Degree) :- X >= 0, X =< 7, Degree is 0.
generous(X, Degree) :- X > 7, X =< 9, Degree is ((X - 7) * (1 / 2)).
generous(X, Degree) :- X > 9, X =< 10, Degree is 1.

cheap_tip(Service, Food, X, Degree) :-
    poor(Service, ServiceD),
    rancid(Food, FoodD),
    max(ServiceD, FoodD, AntecedentsD),
    cheap(X, CheapD),
    min(AntecedentsD, CheapD, Degree).

normal_tip(Service, X, Degree) :-
    good(Service, ServiceD),
    normal(X, NormalD),
    min(ServiceD, NormalD, Degree).

generous_tip(Service, Food, X, Degree) :-
    excellent(Service, ServiceD),
    delicious(Food, FoodD),
    max(ServiceD, FoodD, AntecedentsD),
    generous(X, GenerousD),
    min(AntecedentsD, GenerousD, Degree).

tip_calculator(Service, Food, X) :-
    cheap_tip(Service, Food, X, CT),
    normal_tip(Service, X, NT),
    generous_tip(Service, Food, X, GT),
    max(CT, NT, T1),
    max(GT, T1, Tip),
    write("Probability of getting tip "), write(X), write("%: "), write(Tip).