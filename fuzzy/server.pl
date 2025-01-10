:- ["./utils/read.pl", "./utils/parse.pl", "./utils/utils.pl", "./degree-curves.pl"].
:- use_module(library(socket)).

% :- dynamic stop_server/0.

start_server :-
    tcp_socket(Socket),
    tcp_bind(Socket, 5000),
    tcp_listen(Socket, 1), 
    read_file("./inputs/car-price.txt", KB),
    write("Server started on localhost:5000."), nl,
    write("Waiting for connections..."), nl,
    accept_connections(Socket, KB).

accept_connections(Socket, KB) :-
    % \+ stop_server, 
    tcp_accept(Socket, ClientSocket, _),
    write("Client connected!"), nl,
    handle_client(ClientSocket, KB),
    accept_connections(Socket, KB).
% accept_connections(Socket, KB) :-
    % stop_server, 
    % write("Server stopped."), nl.

handle_client(Socket, KB) :-
    setup_call_cleanup(
        tcp_open_socket(Socket, InStream, OutStream),
        communicate_with_client(InStream, OutStream, KB),
        close_connection(InStream, OutStream)
    ).

communicate_with_client(InStream, OutStream, KB) :-
    read_line_to_string(InStream, Premises),
    (   
        % Premises == "STOP" -> assert(stop_server); 
        writeln("Processing the question from the client..."),
        process_question(Premises, PremisesProcessed),
        writeln("Started computing the price..."), 
        get_price(KB, PremisesProcessed, Price),
        writeln("Price computed!"),
        format(OutStream, '~w~n', [Price]),
        flush_output(OutStream)
    ).

close_connection(InStream, OutStream) :-
    close(InStream),
    close(OutStream),
    write("Client disconnected."), nl.

process_question(Premises, PremisesProcessed) :-
    atom_string(Atom, Premises),
    atom_to_term(Atom, PremisesProcessed, _).

:- initialization(start_server).
