:- ["./degree-curves.pl", "./utils/read.pl", "./utils/utils.pl"].

apply_predicates([], _, []).
apply_predicates([Attribute/Predicate | Predicates], AttributeValues, [Degree | Degrees]) :-
    member(Attribute/Value, AttributeValues),
    call(Predicate, Value, Degree),
    apply_predicates(Predicates, AttributeValues, Degrees).

apply_conjuction([], 1).
apply_conjuction([Degree | Degrees], MinDegree) :- 
    apply_conjuction(Degrees, MinDegreeRecursive),
    min(Degree, MinDegreeRecursive, MinDegree).

apply_disjunction([], 0).
apply_disjunction([Degree | Degrees], MaxDegree) :-
    apply_disjunction(Degrees, MaxDegreeRecursive),
    max(Degree, MaxDegreeRecursive, MaxDegree).

apply_premises(Operator, Premises, Inputs, Result) :-
    Operator = and,
    apply_predicates(Premises, Inputs, Degrees),
    apply_conjuction(Degrees, Result).
apply_premises(Operator, Premises, Inputs, Result) :-
    Operator = or,
    apply_predicates(Premises, Inputs, Degrees),
    apply_disjunction(Degrees, Result).

apply_min_premises_conseq([], _, []).
apply_min_premises_conseq([Premise|Premises], Consequence, [Min|Mins]) :-
    min(Premise, Consequence, Min),
    apply_min_premises_conseq(Premises, Consequence, Mins).

apply_rules([], _, []).
apply_rules([[Operator, Premises, [_/Consequence]]|KB], Inputs, Result) :-
    apply_premises(Operator, Premises, Inputs, ResultPremises),
    findall(
        Y,
        (between(0, 15, X), call(Consequence, X, Y)), 
        ResultConsequence
    ),
    apply_min_premises_conseq(ResultConsequence, ResultPremises, ResultRule),
    apply_rules(KB, Inputs, ResultRuleRecursive),
	max_between_lists(ResultRule, ResultRuleRecursive, Result).

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