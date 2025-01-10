read_file(Filename, Lines) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines), !,
    close(Stream).

line_to_atom(Line, Term) :-
    atom_string(Atom, Line),
    atom_to_term(Atom, Term, _).
        
read_lines(Stream, []) :-
    at_end_of_stream(Stream).
read_lines(Stream, [Atom|Rest]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    line_to_atom(Line, Atom),
    read_lines(Stream, Rest).