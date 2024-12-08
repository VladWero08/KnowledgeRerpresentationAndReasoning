/* Given a sentence as a list of parentheses, predicates
 * and variables, parse the sentence using a grammar and translate
 * it to a Prolog list.
 * */
process_sentence(Sentece, Result) :- translate(Result, Sentece, []).

process_sentences([], []).
process_sentences([Sentece|Sentences], [Result|Results]) :-
    process_sentence(Sentece, Result),
    process_sentences(Sentences, Results).

% match all conjunctions
translate([A|B]) --> disjunction(A), [and], translate(B).
translate([A])   --> disjunction(A).

% match a single disjunction
disjunction(A) --> ['('], list_of_options(A).

list_of_options([Element])   --> [Element, ')'].
list_of_options([Element|T]) --> [Element], [or], list_of_options(T).
