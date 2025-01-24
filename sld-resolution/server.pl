:- ["./utils/read.pl", "./utils/parse.pl", "./utils/utils.pl", "./sld-backward.pl", "./sld-forward.pl"].
:- use_module(library(socket)).

dogs([germanShepherd, rottweiler, beagle]).

start_server :-
    tcp_socket(Socket),
    tcp_bind(Socket, 5000),
    tcp_listen(Socket, 1), 
    load_dogs_kb(KB),
    write("Server started on localhost:5000."), nl,
    write("Waiting for connections..."), nl,
    accept_connections(Socket, KB).

accept_connections(Socket, KB) :-
    tcp_accept(Socket, ClientSocket, _),
    write('Client connected!'), nl,
    handle_client(ClientSocket, KB),
    accept_connections(Socket, KB).

handle_client(Socket, KB) :-
    setup_call_cleanup(
        tcp_open_socket(Socket, InStream, OutStream),
        communicate_with_client(InStream, OutStream, KB),
        close_connection(InStream, OutStream)
    ).

communicate_with_client(InStream, OutStream, KB) :-
    read_line_to_string(InStream, Answers),
    (   Answers == end_of_file
    ->  true 
    ;   
        write("Processing the answers from the client..."), nl,
        process_answers(Answers, AnswersProcessed),
        merge(KB, AnswersProcessed, KBComplete),
        write("Started searching for the right dog..."), nl,
        dogs(Dogs),
        recommend_dogs(KBComplete, Dogs, DogsRecommended),
        format(OutStream, '~w~n', [DogsRecommended]),
        flush_output(OutStream)
    ).

close_connection(InStream, OutStream) :-
    close(InStream),
    close(OutStream),
    write("Client disconnected."), nl.

process_answers(Answers, AnswersParsed) :-
    atom_string(Atom, Answers),
    atom_to_term(Atom, AnswersTerm, _),
    process_sentence(AnswersTerm, AnswersParsed).


load_dogs_kb(KB) :-
    %
    % If the dog should be intelligent and big, then it is protective.
    % If the dog should be protective and trainable, recommend German Shepherd.
    % If the dog should be big and playful, recommend Rottweiler.
    % If the dog should be small and playful, recommend Beagle.
    %
    read_file("./inputs/dogs.txt", KBUnpacked),
    process_sentences(KBUnpacked, KBParsed),
    unpack_kb(KBParsed, KB).

recommend_dogs(_, [], []).
recommend_dogs(KB, [Dog|Dogs], [Result|Results]) :-
    recommend_dogs(KB, Dogs, Results),
    resolution_backward(KB, [Dog], Result).

:- initialization(start_server).