process_sentence(Sentece, Result) :- translate(Result, Sentece, []).

process_sentences([], []).
process_sentences([Sentece|Sentences], [Result|Results]) :-
    process_sentence(Sentece, Result),
    process_sentences(Sentences, Results).

translate([A|B]) --> disjunction(A), [and], translate(B).
translate([A])   --> disjunction(A).

disjunction(A) --> ['('], list_of_options(A).

list_of_options([Element])   --> [Element, ')'].
list_of_options([Element|T]) --> [Element], [or], list_of_options(T).
