% ------------------------------------------------------ CREATE BOARD
create_line(0, []) :- !.
create_line(N, LINE) :-
    N > 0,
    N1 is N - 1,
    create_line(N1, NEW_LINE),
    append([' '], NEW_LINE, LINE).

create_board(N, BOARD) :-
    create_board(N, N, BOARD).
create_board(_, 0, []).
create_board(N, I, BOARD) :-
    N > 0,
    I1 is I - 1,
    create_line(N, LINE),
    create_board(N, I1, NEW_BOARD),
    append([LINE], NEW_BOARD, BOARD).

% ------------------------------------------------------ UPDATE BOARD 

update_board(State, Move, NewState):-
    Move = (Row-Column),
    game_state_pack(State, Board, CurrentPlayer, Opponent, Difficulty),
    place_disc(Row, Column, CurrentPlayer, Board, NewBoard),
    game_state_pack(NewState, NewBoard, CurrentPlayer, Opponent, Difficulty).

% ------------------------------------------------------ PLACE DISC 

place_disc(0, Column, Element, [H|B], [NewH|B]):-
    place_disc(Column, Element, H, NewH),
    !.
place_disc(Row, Column, Element, [H|B], [H|NewB]):-
    Row > 0,
    Row1 is Row - 1,
    place_disc(Row1, Column, Element, B, NewB).
place_disc(0, Element, [_|B], [Element|B]) :- !.
place_disc(I, Element, [H|B], [H|NewB]) :-
    I > 0,
    I1 is I - 1,
    place_disc(I1, Element, B, NewB).

                