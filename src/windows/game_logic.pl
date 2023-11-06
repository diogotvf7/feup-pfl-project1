% ------------------------------------------------------------------------------- VALID MOVES

/**
* Returns all valid moves a player can make on a certain state
*   valid_moves(+State, -ListOfMoves)
*/
valid_moves(State, _):-
    game_over(State, _), !,
    fail.

valid_moves(State, ListOfMoves):-
    game_state_pack(State, Board, _, _, _),
    length(Board, Size),
    valid_moves(State, ListOfMoves, 0, 0, Size).

valid_moves(_, [], Size, _, Size).
valid_moves(State, [H|B], Row, Column, Size):-
    valid_move(Row-Column, State, _),
    H = Row-Column,
    (
        Column == Size -> 
        NextRow is Row + 1, NextColumn = 0; NextRow = Row, NextColumn is Column + 1
    ),
    valid_moves(State, B, NextRow, NextColumn, Size).

valid_moves(State, ListOfMoves, Row, Column, Size):-
    (
        Column == Size -> 
        NextRow is Row + 1, NextColumn = 0; NextRow = Row, NextColumn is Column + 1
    ),
    valid_moves(State, ListOfMoves, NextRow, NextColumn, Size).

% ------------------------------------------------------------------------------- VALUE
    
/**
* Returns the value of a state
*   value(+State, -Value)
*/
value(State, Value):-
    switch_current_player(State, NewState),
    game_over(NewState, Winner), !,
    game_state_pack(State, Board, CurrentPlayer, Opponent, _),
    get_largest_segment(Board, CurrentPlayer, PlayerMaxSeg),
    get_largest_segment(Board, Opponent, OpponentMaxSeg),
    count_pieces(Board, CurrentPlayer, PlayerPieces),
    count_pieces(Board, Opponent, OpponentPieces),
    Value is 10 + PlayerMaxSeg * 2 - OpponentMaxSeg * 2 + PlayerPieces - OpponentPieces.
    Value = 10.

value(State, Value):-
    game_state_pack(State, Board, CurrentPlayer, Opponent, _),
    get_largest_segment(Board, CurrentPlayer, PlayerMaxSeg),
    get_largest_segment(Board, Opponent, OpponentMaxSeg),
    count_pieces(Board, CurrentPlayer, PlayerPieces),
    count_pieces(Board, Opponent, OpponentPieces),
    Value is PlayerMaxSeg * 2 - OpponentMaxSeg * 2 + PlayerPieces - OpponentPieces.

% ------------------------------------------------------------------------------- GET LARGEST SEGMENT

/**
* Returns the size of the largest segment of the given player in the given board
*   get_largest_segment(+Board, +Player, -Max)
*/
get_largest_segment(Board, Player, Max):-
    get_largest_segment_s0(Board, Player, 0-0, Max).

get_largest_segment_s0(Board, Player, Row-Col, Max):-
    mx_valid_position(Board, Row-Col),
    get_largest_segment_s1(Board, Player, Row-Col, Max1),
    length(Board, N),
    NewCol is (Col + 1) mod N,
    (NewCol == 0 -> NewRow is Row + 1; NewRow is Row),
    get_largest_segment_s0(Board, Player, NewRow-NewCol, Max2),
    max(Max1, Max2, Max).

get_largest_segment_s0(_, _, _, 0).

get_largest_segment_s1(Board, Player, Position, Max):-
    mx_get(Position, Board, Player),
    get_largest_segment_s2(Board, Player, Position, up, SizeUp),
    get_largest_segment_s2(Board, Player, Position, down, SizeDown),
    get_largest_segment_s2(Board, Player, Position, left, SizeLeft),
    get_largest_segment_s2(Board, Player, Position, right, SizeRight),
    lmax([SizeUp, SizeDown, SizeLeft, SizeRight], Max).

get_largest_segment_s1(_, _, _, 0).

get_largest_segment_s2(Board, Player, Position, Direction, Size):-
    mx_delta(Position, Direction, NewPosition),
    mx_valid_position(Board, NewPosition),
    mx_get(NewPosition, Board, Player),
    get_largest_segment_s2(Board, Player, NewPosition, Direction, Curr),
    Size is Curr + 1.

get_largest_segment_s2(_, _, _, _, 1).

% ------------------------------------------------------------------------------- COUNT PIECES

/**
* Returns the number of pieces on the given board belonging to the given player
*   count_pieces(+Board, +Player, -Count)
*/
count_pieces(Board, Player, Count):-
    count_pieces_s0(Board, Player, Count).

count_pieces_s0([H|B], Player, Count):-
    count_pieces_s1(H, Player, RowCount),
    count_pieces_s0(B, Player, BoardCount),
    Count is RowCount + BoardCount.

count_pieces_s0([],_,0).

count_pieces_s1([H|T], Player, Count):-
    (H = Player -> Count1 = 1; Count1 = 0),
    count_pieces_s1(T, Player, Count2),
    Count is Count1 + Count2.

count_pieces_s1([],_,0).

% ------------------------------------------------------------------------------- BEST MOVE

best_move(State, BestMove, Depth):-
    game_state_pack(State, Board, Max, _, _),
    switch_current_player(State, StartState),
    depth_value(Max, StartState, BestMove, _, Depth).

depth_value(_, State, _, Val, 0):-
    value(State, Val).

depth_value(Max, State, BestMove, Val, Depth):-
    Depth1 is Depth - 1,
    switch_current_player(State, NewState),  
    valid_moves(NewState, ListOfMoves), !,
    % write_n_times('------------------------------------------------------------------------------------', Depth),   
    % write(' Depth: '), write(Depth1), nl,
    % write('State: '), write(NewState), nl,
    % write('Valid moves: '), write(ListOfMoves), nl, nl,
    best_move(Max, NewState, ListOfMoves, BestMove, Val, Depth1);
    value(State, Val).

best_move(Max, State, [Move], Move, Val, Depth):-
    valid_move(Move, State, NewState),
    depth_value(Max, NewState, _, Val, Depth),
    !.

best_move(Max, State, [Move1|B], BestMove, BestVal, Depth):-
    valid_move(Move1, State, NewState),
    depth_value(Max, NewState, _, Val1, Depth),
    best_move(Max, State, B, Move2, Val2, Depth),
    compare_state(Max, State, Move1, Val1, Move2, Val2, BestMove, BestVal).
    % write('(Depth '), write(Depth), write(') | '),
    % write('Local best move '), write(BestMove), write(' - '), write(BestVal), nl, nl.

compare_state(Max, State, Move1, Val1, Move2, Val2, Move1, Val1):-
    game_state_pack(State, _, CurrentPlayer, _, _),
    % nl, write('State: '), write(State), nl,
    % write(Move1), write(' : '), write(Val1), write(' points                             '),
    % write(Move2), write(' : '), write(Val2), write(' points\n'),
    (
        CurrentPlayer \== Max, Val1 < Val2, !;
        CurrentPlayer == Max, Val1 > Val2, !
    ).
    
compare_state(Max, _, _, _, Move2, Val2, Move2, Val2).

% ------------------------------------------------------------------------------- CHOOSE MOVE

/**
* Randomly chooses a move for the given player from all the valid moves on that state
*   choose_move(+State, +Player, -Move)
*/
choose_move(State, Player, Move):-
    game_state_pack(State, _, _, _, 1),
    valid_moves(State, ListOfMoves),
    random_member(Move, ListOfMoves).

/**
* Chooses the best move according to the minimax algorithm (best_move/3)
*   choose_move(+State, +Player, -Move)
*/
choose_move(State, Player, BestMove):-
    game_state_pack(State, Board, _, _, 2),
    length(Board, Size),
    (
        (Size == 10; Size == 9; Size == 8) -> Depth = 2;
        Size == 7  -> Depth = 3;
        Size == 6  -> Depth = 4;
        Size == 5  -> Depth = 6
    ),
    best_move(State, BestMove, Depth).

% ------------------------------------------------------------------------------- VALID MOVE

/**
* Checks if the resulting state from a move is valid
*   valid_move(+State, -NewState)
*/
valid_move(State, NewState):-
    game_state_pack(State, Board, Player, _, _),
    length(Board, Size),
    (
        Player == 'Player 1' ->
        (
            write('\n Player 1 turn\n\n'),
            read_move(Size, Move),
            valid_move(Move, State, NewState); 
            write('Invalid move!\n'), valid_move(State, NewState)
        );
        Player == 'Player 2' ->
        (
            write('\n Player 2 turn\n\n'),
            read_move(Size, Move),
            valid_move(Move, State, NewState); 
            write('Invalid move!\n'), valid_move(State, NewState)
        );
        (Player == 'Computer 1') ->
        (   
            write('\n Computer 1 turn\n\n'),
            prompt(_, ' PRESS ENTER'),
            choose_move(State, Player, Move),
            valid_move(Move, State, NewState),
            get_int(_, 0, 0),
            prompt(_, '|:')
        );
        (Player == 'Computer 2') ->
        (   
            write('\n Computer 2 turn\n\n'),
            prompt(_, ' PRESS ENTER'),
            choose_move(State, Player, Move),
            valid_move(Move, State, NewState),
            get_int(_, 0, 0),
            prompt(_, '|:')
        )
    ).

/**
* Checks if a move is valid
*   valid_move(+Move, +State, -NewState)
*/
valid_move(Move, State, NewState):-
    game_state_pack(State, Board, _, _, _),
    length(Board, Size),
    Size1 is Size - 1,
    Move \= 0-X, Move \= Size1-X, Move \= X-0, Move \= X-Size1,
    mx_get(Move, Board, ' '),
    update_board(State, Move, S1),
    check_flanking(Move, S1, NewState, 0).

valid_move(Move, State, NewState):-
    game_state_pack(State, Board, _, _, _),
    length(Board, Size),
    Size1 is Size - 1,
    Move = Row-Column,
    (Row == 0; Row == Size1; Column == 0; Column == Size1),
    check_flanking(Move, State, NewState, 1),
    State \= NewState.

% ------------------------------------------------------------------------------- CHECK FLANKING
/**
* Checks if any flanking happened due to a new made move
*   check_flanking(+Start, +State, -NewState, +IsPerimeter)
*/
check_flanking(Start, State, NewState, IsPerimeter):-
    get_flank(Start, up, State, S1, IsPerimeter),
    get_flank(Start, down, S1, S2, IsPerimeter),
    get_flank(Start, left, S2, S3, IsPerimeter),
    get_flank(Start, right, S3, NewState, IsPerimeter).

% ------------------------------------------------------------------------------- CHECK SEGMENT

/**
* Checks for validity of a flank, if theres no cutting of a bigger segment than the flanking itself.
*   get_flank(+Position, +Direction, +State, -NewState, +Flank, +Cut)
*/
get_flank(Position, Direction, State, NewState, 0):-
    get_flank_s0(Position, Direction, State, NewState, Flank, Cut),
    array_cmp(Flank, Cut, Flank).

get_flank(Position, Direction, State, NewState, 1):-
    get_flank_s1(Position, Direction, State, NewState, Flank, Cut),
    array_cmp(Flank, Cut, Flank).

get_flank(_, _, State, State, _).

get_flank_s0(Position, Direction, State, NewState, [Position|Flank], Cut):-
    get_flank_s1(Position, Direction, State, NewState, Flank, Cut).

get_flank_s1(Position, Direction, State, NewState, [NewPosition|Flank], Cut):-
    game_state_pack(State, Board, _, Opponent, _),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    perpendicular(Direction, Perpendicular),
    get_cut_s0(NewPosition, Perpendicular, State, CurrentCut),
    get_flank_s2(NewPosition, Direction, State, S1, Flank, CarriedCut),
    array_cmp(CurrentCut, CarriedCut, Cut),
    update_board(S1, NewPosition, NewState).

get_flank_s2(Position, Direction, State, NewState, [NewPosition|Flank], Cut):-
    game_state_pack(State, Board, _, Opponent, _),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    perpendicular(Direction, Perpendicular),
    get_cut_s0(NewPosition, Perpendicular, State, CurrentCut),
    get_flank_s2(NewPosition, Direction, State, S1, Flank, CarriedCut),
    array_cmp(CurrentCut, CarriedCut, Cut),
    update_board(S1, NewPosition, NewState).

get_flank_s2(Position, Direction, State, State, [NewPosition], []):-
    game_state_pack(State, Board, CurrentPlayer, _, _),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, CurrentPlayer).
    
% ------------------------------------------------------------------------------- COUNT 

/**
* Returns the biggest cut a flanking move will do
*   get_cut_s0(+Position, +Direciton1-Direction2, +State, -Cut)
*/
get_cut_s0(Position, Direction1-Direction2, State, Cut):-
    get_cut_s1(Position, Direction1, State, Cut1),
    get_cut_s1(Position, Direction2, State, Cut2),
    reverse(Cut1, Cut1R),
    append([Cut1R, [Position], Cut2], Cut).

get_cut_s1(Position, Direction, State, [NewPosition|Cut]):-
    game_state_pack(State, Board, _, Opponent, _),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    get_cut_s1(NewPosition, Direction, State, Cut),
    !.

get_cut_s1(_, _, _, []):- !.

% ------------------------------------------------------ WINNING CONDITION
/**
* Check if the current game meets any of the ending conditions and if so returns the winner
*   game_over(+State, -Winner)
*/
game_over(State, Winner):-
    game_state_pack(State, Board, _, Opponent, _),
    (check_rows(Opponent, Board) ; check_columns(Opponent, Board)),
    Winner = Opponent.
    
% ------------------------------------------------------ CHECK ROWS

/**
* Check if there are any completed rows with pieces only belonging to the given player.
*   check_rows(+CurrentPlayer, +[H])
*/
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

/**
* Check if there are any completed columns with pieces only belonging to the given player.
*   check_columns(+CurrentPlayer, +[H])
*/
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

    
