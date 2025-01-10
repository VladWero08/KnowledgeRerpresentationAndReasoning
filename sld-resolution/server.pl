:- ["./utils/read.pl", "./utils/parse.pl", "./utils/utils.pl", "./sld-backward.pl", "./sld-forward.pl"].
:- use_module(library(socket)).

start_server :-
    tcp_socket(Socket),
    tcp_bind(Socket, 5000),
    tcp_listen(Socket, 1), 
    load_kb(KB),    
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
    read_line_to_string(InStream, Question),
    (   Question == end_of_file
    ->  true 
    ;   
        write("Processing the question from the client..."), nl,
        process_question(Question, QuestionProcessed),
        write("Started solving the question..."), nl,
        solve_question(QuestionProcessed, KB, Result),
        format(OutStream, '~w~n', [Result]),
        flush_output(OutStream)
    ).

close_connection(InStream, OutStream) :-
    close(InStream),
    close(OutStream),
    write("Client disconnected."), nl.

load_kb(KB) :-
    read_file("./inputs/kb.txt", KBUnpacked),
    process_sentences(KBUnpacked, KBParsed),
    unpack_kb(KBParsed, KB),
    write(KB), nl.

process_question(Question, QuestionProcessed) :-
    atom_string(Atom, Question),
    atom_to_term(Atom, QuestionTerm, _),
    process_sentence(QuestionTerm, QuestionParsed),
    unpack_kb(QuestionParsed, QuestionProcessed).

solve_question(Question, KB, Result) :-
    copy_term(KB, KBCopy),
    append([Question], KBCopy, KBQuestion),
    resolution(KBQuestion, Result).

:- initialization(start_server).