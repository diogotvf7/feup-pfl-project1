% ------------------------------------------------------------------------------- VALID MOVE
valid_move(State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    (Player == '1' ->
        write('\n\e[93m Player 1 turn\e[0m\n\n');
        write('\n\e[95m Player 2 turn\e[0m\n\n')
    ),
    read_move(Size, Move),
    valid_move(Move, State, NewState).

valid_move(Move, State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    Size1 is Size - 1,
    Move \= 0-X, Move \= Size1-X, Move \= X-0, Move \= X-Size1,
    mx_get(Move, Board, ' '),
    update_board(State, Move, S1),
    check_flanking(Move, S1, NewState, 0).

valid_move(Move, State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    Size1 is Size - 1,
    Move = Row-Column,
    (Row == 0; Row == Size1; Column == 0; Column == Size1),
    check_flanking(Move, State, NewState, 1),
    State \= NewState.

valid_move(Move, State, NewState):-
    write('Invalid move!\n'),
    valid_move(State, NewState).

% ------------------------------------------------------------------------------- CHECK FLANKING

check_flanking(Start, State, NewState, IsPerimeter):-
    get_flank(Start, up, State, S1, IsPerimeter),
    get_flank(Start, down, S1, S2, IsPerimeter),
    get_flank(Start, left, S2, S3, IsPerimeter),
    get_flank(Start, right, S3, NewState, IsPerimeter).

% ------------------------------------------------------------------------------- CHECK SEGMENT

get_flank(Position, Direction, State, NewState, 0):-
    get_flank_s0(Position, Direction, State, NewState, Flank, Cut),
    write('Flank: '), write(Flank), write('\n'),
    write('Cut: '), write(Cut), write('\n'),
    length(Flank, FlankLength),
    length(Cut, CutLength),
    FlankLength > CutLength.

get_flank(Position, Direction, State, NewState, 1):-
    get_flank_s1(Position, Direction, State, NewState, Flank, Cut),
    write('Flank: '), write(Flank), write('\n'),
    write('Cut: '), write(Cut), write('\n'),
    length(Flank, FlankLength),
    length(Cut, CutLength),
    FlankLength > CutLength.

get_flank(Position, Direction, State, State, _).

get_flank_s0(Position, Direction, State, NewState, [Position|Flank], Cut):-
    get_flank_s1(Position, Direction, State, NewState, Flank, Cut).

get_flank_s1(Position, Direction, State, NewState, [NewPosition|Flank], Cut):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    perpendicular(Direction, Perpendicular),
    % trace,    % TODO: remove
    get_cut_s0(NewPosition, Perpendicular, State, CurrentCut),
    notrace,    % TODO: remove
    write('CurrentCut: '), write(CurrentCut), write('\n'),
    get_flank_s2(NewPosition, Direction, State, S1, Flank, CarriedCut),
    array_cmp(CurrentCut, CarriedCut, Cut),
    update_board(S1, NewPosition, NewState).

get_flank_s2(Position, Direction, State, NewState, [NewPosition|Flank], Cut):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    perpendicular(Direction, Perpendicular),
    % trace,    % TODO: remove
    get_cut_s0(NewPosition, Perpendicular, State, CurrentCut),
    notrace,    % TODO: remove
    write('CurrentCut: '), write(CurrentCut), write('\n'),
    get_flank_s2(NewPosition, Direction, State, S1, Flank, CarriedCut),
    array_cmp(CurrentCut, CarriedCut, Cut),
    update_board(S1, NewPosition, NewState).

get_flank_s2(Position, Direction, State, State, [NewPosition], Cut):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, CurrentPlayer).
    
% ------------------------------------------------------------------------------- COUNT CUT
get_cut_s0(Position, Direction1-Direction2, State, Cut):-
    % notrace,
    get_cut_s1(Position, Direction1, State, Cut1),
    get_cut_s1(Position, Direction2, State, Cut2),
    reverse(Cut1, Cut1R),
    append([Cut1R, [Position], Cut2], Cut),
    write('Cut1R: '), write(Cut1R), write('\n'),
    write('[Position]: '), write([Position]), write('\n'),
    write('[Position]: '), write([Position]), write('\n'),
    write('Cut2: '), write(Cut2), write('\n'),
    write('Cut after append: '), write(Cut), write('\n'),
    trace
    .

get_cut_s1(Position, Direction, State, [NewPosition|Cut]):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    get_cut_s1(NewPosition, Direction, State, Cut),
    !.

get_cut_s1(Position, Direction, State, []):- !.

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
% ------------------------------------------------------ WINNING CONDITION

game_over(State, Winner):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    (check_rows(Opponent, Board) ; check_columns(Opponent, Board)),
    Winner = Opponent.
    

% ------------------------------------------------------ CHECK ROWS

check_rows(CurrentPlayer, [H]):-
    check_full_row(CurrentPlayer, H, 0).
check_rows(CurrentPlayer, [H|B]):-
    check_full_row(CurrentPlayer, H, 0); check_rows(CurrentPlayer, B).

check_full_row(CurrentPlayer, [_|B], 0):-
    check_full_row(CurrentPlayer, B, 1).
check_full_row(CurrentPlayer, [H|B], 1):-
    H == CurrentPlayer,
    check_full_row(CurrentPlayer, B, 1).
check_full_row(_, [_], 1).


% ------------------------------------------------------ CHECK COLUMNS

check_columns(CurrentPlayer, Board):-
    length(Board, N),
    N1 is N - 2,
    check_columns(CurrentPlayer, Board, N1).
    
check_columns(CurrentPlayer, Board, 1):-
    check_full_column(CurrentPlayer, Board, 1).

check_columns(CurrentPlayer, Board, N):-
    N > 1,
    (N1 is N - 1, check_columns(CurrentPlayer, Board, N1)) ; check_full_column(CurrentPlayer, Board, N).

check_full_column(CurrentPlayer, Board, Col):-
    length(Board, N),
    N1 is N - 1,
    check_full_column(CurrentPlayer, Board, 1, Col, N1).

check_full_column(_, _, N, _, N).

check_full_column(CurrentPlayer, Board, Row, Col, N):-
    mx_get(Row-Col, Board, CurrentPlayer),
    NewRow is Row + 1,
    check_full_column(CurrentPlayer, Board, NewRow, Col, N).

    
