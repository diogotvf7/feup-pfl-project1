valid_move(State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    read_move(Size, Move),
    mx_get(Move, Board, ' '),
    update_board(State, Move, S1),
    cls,
    check_flanking(Move, S1, S2),
    switch_current_player(S2, NewState).

valid_move(State, NewState):-
    write('Invalid move!\n'),
    valid_move(State, NewState).

% ------------------------------------------------------ FLANKING

check_flanking(Start, State, NewState):-
    check_segment(Start, up, State, NewState, 0);
    check_segment(Start, down, State, NewState, 0);
    check_segment(Start, left, State, NewState, 0);
    check_segment(Start, right, State, NewState, 0).

check_segment(Position, Direction, State, NewState, 0):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    Move = (Row-Col),
    mx_delta(Position, Direction, NewPosition),
    NewPosition = (NewRow-NewCol),
    mx_get(NewPosition, Board, Piece),
    Piece = Opponent,
    check_segment(NewPosition, Direction, State, NewState, 1),
    update_board(State, Move, NewState).

check_segment(Position, Direction, State, NewState, 1):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    Move = (Row-Col),
    mx_delta(Position, Direction, NewPosition),
    NewPosition = (NewRow-NewCol),
    mx_get(NewPosition, Board, Piece),
    Piece = CurrentPlayer,
    update_board(State, Move, NewState).

check_segment(Position, Direction, State, NewState, 1):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    Move = (Row-Col),
    mx_delta(Position, Direction, NewPosition),
    NewPosition = (NewRow-NewCol),
    mx_get(NewPosition, Board, Piece),
    Piece = CurrentPlayer,
    update_board(State, Move, NewState).

% ------------------------------------------------------ UPDATE BOARD 
update_board(State, Move, NewState):-
    Move = (Row-Column),
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    place_disc(Row, Column, CurrentPlayer, Board, NewBoard),
    game_state_pack(NewState, NewBoard, CurrentPlayer, Opponent).

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
% ------------------------------------------------------ 

% winning_condition(State, Winner):-
winning_condition(State):-
    false.