/* Reads the content of a given file, line by line.
 * */
read_file(Filename, Lines) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).

/* Trasnforms the given line into a Prolog valid atom.
 * */
line_to_atom(Line, Term) :-
    atom_string(Atom, Line),
    atom_to_term(Atom, Term, _).
        
/* Given a stream, reads each line and processes it into
 * a Prolog atom. It returns a list of processed atoms.
 * */
read_lines(Stream, []) :-
    at_end_of_stream(Stream).
read_lines(Stream, [Atom|Rest]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    line_to_atom(Line, Atom),
    read_lines(Stream, Rest).