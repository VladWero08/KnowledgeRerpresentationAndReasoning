:- ["./degree-curves.pl", "./utils/read.pl", "./utils/utils.pl"].

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