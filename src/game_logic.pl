valid_move(State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    read_move(Size, Move),
    (check_valid_move(State, Move) ->
        update_board(State, Move, NewState)
        ;
        write('Invalid move!\n'),
        valid_move(State, NewState)
    ).

check_valid_move(State, Move):-
    game_state_pack(State, Board, Player, Opponent),
    Move = (Row-Column),
    nth0(Row, Board, BoardRow),
    nth0(BoardColumn, BoardRow, Element),
    Element == ' '.

update_board(State, Move, NewState):-
    Move = (Row-Column),
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    (CurrentPlayer = player1 ->
        place_disc(Row, Column, '1', Board, NewBoard);
        place_disc(Row, Column, '2', Board, NewBoard)
    ),
    game_state_pack(NewState, NewBoard, Opponent, CurrentPlayer).


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

% flipping()

winning_condition(State):-
    false.