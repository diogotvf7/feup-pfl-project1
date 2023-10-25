:- use_module(library(lists)).
:- ['src/board.pl'].
:- ['src/io.pl'].
:- ['src/game_logic.pl'].

run:-
    write('Size of board: '), nl,
    read(SIZE), nl,
    write(SIZE), nl,
    create_board(SIZE, ' ', BOARD),
    write('Board: '), nl,
    print_board(BOARD), nl, nl, nl, nl,
    place(BOARD, 3, 3, '1', NEW_BOARD),
    place(NEW_BOARD, 4, 4, '1', NEW_BOARD1),
    place(NEW_BOARD1, 7, 5, '2', NEW_BOARD2),
    place(NEW_BOARD2, 1, 1, '2', NEW_BOARD3),
    print_board(NEW_BOARD3).

:- cls, run.