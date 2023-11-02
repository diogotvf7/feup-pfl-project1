% ------------------------------------------------------ CREATE BOARD
create_line(0, _, []) :- !.
create_line(N, ELEMENT, LINE) :-
    N > 0,
    N1 is N - 1,
    create_line(N1, ELEMENT, NEW_LINE),
    append([ELEMENT], NEW_LINE, LINE).

create_board(N, ELEMENT, BOARD) :-
    create_board(N, N, ELEMENT, BOARD).
create_board(_, 0, _, []).
create_board(N, I, ELEMENT, BOARD) :-
    N > 0,
    I1 is I - 1,
    create_line(N, ELEMENT, LINE),
    create_board(N, I1, ELEMENT, NEW_BOARD),
    append([LINE], NEW_BOARD, BOARD).


                