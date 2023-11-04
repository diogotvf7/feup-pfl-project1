% ------------------------------------------------------ CREATE BOARD
create_line(0, []) :- !.
create_line(N, LINE) :-
    N > 0,
    N1 is N - 1,
    create_line(N1, NEW_LINE),
    append([x], NEW_LINE, LINE).

create_board(N, BOARD) :-
    create_board(N, N, BOARD).
create_board(_, 0, []).
create_board(N, I, BOARD) :-
    N > 0,
    I1 is I - 1,
    create_line(N, LINE),
    create_board(N, I1, NEW_BOARD),
    append([LINE], NEW_BOARD, BOARD).


                