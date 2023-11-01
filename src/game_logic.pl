% valid_move(State, NewState):-
%     game_state_pack(State, Board, Player, Opponent),
%     length(Board, Size),
%     read_move(Size, Move),
%     Size1 is Size - 1,
%     Move \= 0-X,
%     Move \= Size1-X,
%     Move \= X-0,
%     Move \= X-Size1,
%     mx_get(Move, Board, ' '),
%     update_board(State, Move, S1),
%     check_flanking(Move, S1, S2),
%     switch_current_player(S2, NewState).

valid_move(State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    read_move(Size, Move),
    valid_move(Move, State, NewState).

valid_move(Move, State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    Size1 is Size - 1,
    Move \= 0-X, Move \= Size1-X, Move \= X-0, Move \= X-Size1,
    mx_get(Move, Board, ' '),
    update_board(State, Move, S1),
    check_flanking(Move, S1, S2, 0),
    switch_current_player(S2, NewState).

valid_move(Move, State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    Size1 is Size - 1,
    Move = Row-Column,
    (Row == 0; Row == Size1; Column == 0; Column == Size1),
    check_flanking(Move, State, S1, 1),
    State \= S1,
    switch_current_player(S1, NewState).

valid_move(Move, State, NewState):-
    write('Invalid move!\n'),
    valid_move(State, NewState).

% ------------------------------------------------------------------------------- CHECK FLANKING
check_flanking(Start, State, NewState, IsPerimeter):-
    check_segment(Start, up, State, S1, 0, IsPerimeter),
    check_segment(Start, down, S1, S2, 0, IsPerimeter),
    check_segment(Start, left, S2, S3, 0, IsPerimeter),
    check_segment(Start, right, S3, NewState, 0, IsPerimeter).

% ------------------------------------------------------------------------------- CHECK SEGMENT
check_segment(Position, Direction, State, NewState, 0, 0):-
    check_segment(Position, Direction, State, NewState, 0, FlankLength, CutLength),
    FlankLength > CutLength.

check_segment(Position, Direction, State, NewState, 0, 1):-
    check_segment(Position, Direction, State, NewState, 0, FlankLength, CutLength),
    RealFlankLength is FlankLength - 1,
    RealFlankLength > CutLength.

check_segment(Position, Direction, State, State, 0, _).

check_segment(Position, Direction, State, NewState, 0, FlankLength, CutLength):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == Opponent,
    perpendicular(Direction, Perpendicular),
    count_cut(NewPosition, Perpendicular, State, Count),
    check_segment(NewPosition, Direction, State, S1, 1, FL, CL),
    max(Count, CL, CutLength),
    update_board(S1, NewPosition, NewState),
    FlankLength is FL + 1,
    !.

check_segment(Position, Direction, State, State, 0, 0, 0).

check_segment(Position, Direction, State, NewState, 1, FlankLength, CutLength):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == Opponent,
    perpendicular(Direction, Perpendicular),
    count_cut(NewPosition, Perpendicular, State, Count),
    check_segment(NewPosition, Direction, State, S1, 1, FL, CL),
    max(Count, CL, CutLength),
    update_board(S1, NewPosition, NewState),
    FlankLength is FL + 1.

check_segment(Position, Direction, State, State, 1, 2, 0):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == CurrentPlayer.
    
% ------------------------------------------------------------------------------- COUNT CUT
count_cut(Position, vertical, State, Count):-
    count_cut(Position, up, State, CountUp),
    count_cut(Position, down, State, CountDown),
    Count is CountUp + CountDown + 1.

count_cut(Position, horizontal, State, Count):-
    count_cut(Position, left, State, CountLeft),
    count_cut(Position, right, State, CountRight),
    Count is CountLeft + CountRight + 1.

count_cut(Position, Direction, State, Count):-
    Direction \== vertical,
    Direction \== horizontal,
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == Opponent,
    count_cut(NewPosition, Direction, State, Count1),
    Count is Count1 + 1.

count_cut(Position, Direction, State, 0).

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