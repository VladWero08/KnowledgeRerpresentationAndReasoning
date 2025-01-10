:- ["./utils/read.pl", "./utils/parse.pl", "./utils/utils.pl"].

new_aged(X, Degree) :- X >= 0, X =< 2, Degree is 1.
new_aged(X, Degree) :- X > 2, X =< 5, Degree is (1 - (X - 2) / 3).
new_aged(X, Degree) :- X > 5, X =< 15, Degree is 0.

middle_aged(X, Degree) :- X >= 0, X =< 3, Degree is 0.
middle_aged(X, Degree) :- X > 3, X < 5, Degree is (3 / 2 - X / 2).
middle_aged(X, Degree) :- X >= 5, X =< 8, Degree is 1.
middle_aged(X, Degree) :- X > 8, X =< 10, Degree is (5 - X / 2).
middle_aged(X, Degree) :- X >= 10, X =< 15, Degree is 0.

old_aged(X, Degree) :- X >= 0, X =< 7, Degree is 0.
old_aged(X, Degree) :- X > 7, X < 10, Degree is (X / 3 - 7 / 3).
old_aged(X, Degree) :- X >= 10, X =< 15, Degree is 1.


low_consum(X, Degree) :- X >= 0, X =< 1, Degree is 1.
low_consum(X, Degree) :- X > 1, X =< 6, Degree is (-1 / 5) * (X - 1) + 1.
low_consum(X, Degree) :- X > 6, X =< 15, Degree is 0.

medium_consum(X, Degree) :- X >= 0, X =< 4, Degree is 0.
medium_consum(X, Degree) :- X > 4, X < 5, Degree is X - 4.
medium_consum(X, Degree) :- X >= 5, X =< 8, Degree is 1.
medium_consum(X, Degree) :- X > 8, X < 11, Degree is (-1 / 3) * (X - 8) + 1.
medium_consum(X, Degree) :- X >= 11, X =< 15, Degree is 0.

high_consum(X, Degree) :- X >= 0, X =< 7, Degree is 0.
high_consum(X, Degree) :- X > 7, X < 12, Degree is (1 / 5) * (X - 7).
high_consum(X, Degree) :- X >= 12, X =< 15, Degree is 1.


low_mileage(X, Degree) :- X >= 0, X =< 50000, Degree is 1.
low_mileage(X, Degree) :- X > 50000, X =< 100000, Degree is 1 - (X - 50000) / 50000.
low_mileage(X, Degree) :- X > 100000, X =< 200000, Degree is 0.

medium_mileage(X, Degree) :- X >= 0, X =< 70000, Degree is 0.
medium_mileage(X, Degree) :- X > 70000, X =< 110000, Degree is (X - 70000) / 40000.
medium_mileage(X, Degree) :- X >= 110000, X =< 130000, Degree is 1.
medium_mileage(X, Degree) :- X > 130000, X < 170000, Degree is 1 - (X - 130000) / 40000.
medium_mileage(X, Degree) :- X >= 170000, X =< 200000, Degree is 0.

high_mileage(X, Degree) :- X >= 0, X =< 150000, Degree is 0.
high_mileage(X, Degree) :- X > 150000, X < 190000, Degree is (X - 150000) / 40000.
high_mileage(X, Degree) :- X >= 190000, X =< 200000, Degree is 1.


low_price(X, Degree) :- X >= 0, X =< 2, Degree is 1.
low_price(X, Degree) :- X > 2, X =< 5, Degree is 1 - (X - 2) / 3.
low_price(X, Degree) :- X > 5, X =< 15, Degree is 0.

medium_price(X, Degree) :- X >= 0, X =< 3, Degree is 0.
medium_price(X, Degree) :- X > 3, X < 6, Degree is (X - 3) / 3.
medium_price(X, Degree) :- X >= 6, X =< 9, Degree is 1.
medium_price(X, Degree) :- X > 9, X < 12, Degree is 1 - (X - 9) / 3.
medium_price(X, Degree) :- X >= 12, X =< 15, Degree is 0.

high_price(X, Degree) :- X >= 0, X =< 8, Degree is 0.
high_price(X, Degree) :- X > 8, X < 13, Degree is (X - 8) / 5.
high_price(X, Degree) :- X >= 13, X =< 15, Degree is 1.


apply_predicates([], _, []).
apply_predicates([Attribute/Predicate | Predicates], AttributeValues, [Degree | Degrees]) :-
    member(Attribute/Value, AttributeValues),
    call(Predicate, Value, Degree),
    apply_predicates(Predicates, AttributeValues, Degrees).

apply_conjuction([], 1).
apply_conjuction([Probability | Probabilities], R) :- 
    apply_conjuction(Probabilities, RRecursive),
    min(Probability, RRecursive, R).

apply_disjunction([], 0).
apply_disjunction([Probability | Probabilities], R) :-
    apply_disjunction(Probabilities, RRecursive),
    max(Probability, RRecursive, R).

apply_premises(Operator, Premises, Inputs, Result) :-
    Operator = and,
    apply_predicates(Premises, Inputs, Degrees),
    apply_conjuction(Degrees, Result).
apply_premises(Operator, Premises, Inputs, Result) :-
    Operator = or,
    apply_predicates(Premises, Inputs, Degrees),
    apply_disjunction(Degrees, Result).

apply_min_premises([], _, []).
apply_min_premises([Premise|Premises], Consequence, [Min|Mins]) :-
    min(Premise, Consequence, Min),
    apply_min_premises(Premises, Consequence, Mins).

apply_rules([], _, []).
apply_rules([[Operator, Premises, [_/Consequence]]|KB], Inputs, Result) :-
    apply_premises(Operator, Premises, Inputs, ResultPremises),
    findall(
        ResultConsequence,
        (between(0, 15, X), call(Consequence, X, ResultConsequence)), 
        ResultsConsequence
    ),
    apply_min_premises(ResultsConsequence, ResultPremises, ResultCurr),
    apply_rules(KB, Inputs, ResultRecurr),
	max_between_lists(ResultCurr, ResultRecurr, Result).

get_centroid_price(Ys, Price) :-
	interval(0, 15, Xs),
    sum(Ys, YSum),
    sum_between_lists_product(Xs, Ys, XYSum),
    Price is XYSum / YSum.

get_price(KB, Inputs, Price) :-
	apply_rules(KB, Inputs, Ys),
    get_centroid_price(Ys, Price).
       
solve :-
    read_file("./inputs/car-price.txt", KB),
    get_price(KB, [age/3, consumption/8, mileage/100000], Price),
    writeln(Price).