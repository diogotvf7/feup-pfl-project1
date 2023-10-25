place(BOARD, X, Y, ELEMENT, NEW_BOARD) :-
    nth1(Y, BOARD, ROW),
    place(X, ELEMENT, ROW, NEW_ROW),
    place(Y, NEW_ROW, BOARD, NEW_BOARD).

place(1, ELEMENT, [_|T], [ELEMENT|T]) :- !.
place(I, ELEMENT, [H|T], [H|NEW_T]) :-
    I > 1,
    I1 is I - 1,
    place(I1, ELEMENT, T, NEW_T).

