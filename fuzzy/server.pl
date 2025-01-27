:- ["./utils/read.pl", "./utils/parse.pl", "./utils/utils.pl", "./fuzzy-logic.pl"].
:- use_module(library(socket)).

start_server :-
    tcp_socket(Socket),
    tcp_bind(Socket, 5000),
    tcp_listen(Socket, 1), 
    read_file("./inputs/car-price.txt", KB),
    write("Server started on localhost:5000."), nl,
    write("Waiting for connections..."), nl,
    accept_connections(Socket, KB).

accept_connections(Socket, KB) :-
    tcp_accept(Socket, ClientSocket, _),
    write("Client connected!"), nl,
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
    -> true
    ;   ( Answers == "stop"
        ->  write("Stop command received. Shutting down server..."), nl,
            format(OutStream, "Server shutting down.~n", []),
            flush_output(OutStream),
            halt
        ;   writeln("Processing the question from the client..."),
            process_answers(Answers, AnswersProcessed),
            writeln("Started computing the price..."), 
            get_price(KB, AnswersProcessed, Price),
            writeln("Price computed!"),
            format(OutStream, '~w~n', [Price]),
            flush_output(OutStream)
        )
    ).

close_connection(InStream, OutStream) :-
    close(InStream),
    close(OutStream),
    write("Client disconnected."), nl.

process_answers(Answers, AnswersProcessed) :-
    atom_string(Atom, Answers),
    atom_to_term(Atom, AnswersProcessed, _).

:- initialization(start_server).
