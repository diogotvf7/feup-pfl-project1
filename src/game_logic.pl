% ------------------------------------------------------------------------------- VALID MOVE
valid_move(State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    (Player == '1' ->
        write('\n\e[91m Player 1 turn\e[0m\n\n');
        write('\n\e[94m Player 2 turn\e[0m\n\n')
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
    check_flanking(Move, S1, S2, 0),
    switch_current_player(S2, NewState).

valid_move(Move, State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    Size1 is Size - 1,
    Move = Row-Column,
    (Row == 0; Row == Size1; Column == 0; Column == Size1),
    write('Trying to place a disc in the perimeter!\n'),
    check_flanking(Move, State, S1, 1),
    State \= S1,
    switch_current_player(S1, NewState).

valid_move(Move, State, NewState):-
    write('Invalid move!\n'),
    valid_move(State, NewState).

% ------------------------------------------------------------------------------- CHECK FLANKING
check_flanking(Start, State, NewState, IsPerimeter):-
    check_segment(Start, up, State, S1, IsPerimeter),
    check_segment(Start, down, S1, S2, IsPerimeter),
    check_segment(Start, left, S2, S3, IsPerimeter),
    check_segment(Start, right, S3, NewState, IsPerimeter).

% ------------------------------------------------------------------------------- CHECK SEGMENT

/**
 * Nao sei porque isto esta a dar um bug quando corremos 
 * o tabuleiro 10x10 a verificar os cuts:
 * Jogando (1-1), (1-2), (1-3), (1-4), (1-5), (1-6), (1-7), (1-8)
 * Na ultima jogada o programa trava
 * 
 */

check_segment(Position, Direction, State, NewState, 0):-
    check_segment_s1(Position, Direction, State, NewState, FlankLength, CutLength),
    write('FlankLength: '), write(FlankLength), write('\n'),                                    % DEBUG
    write('CutLength: '), write(CutLength), write('\n'),                                        % DEBUG
    write('FlankLength > CutLength: '), write(FlankLength > CutLength), write('\n'),            % DEBUG
    FlankLength > CutLength.

check_segment(Position, Direction, State, NewState, 1):-
    % trace,
    check_segment_s1(Position, Direction, State, NewState, FlankLength, CutLength),
    RealFlankLength is FlankLength - 1,
    write('RealFlankLength: '), write(RealFlankLength), write('\n'),                            % DEBUG
    write('CutLength: '), write(CutLength), write('\n'),                                        % DEBUG
    write('RealFlankLength > CutLength: '), write(RealFlankLength > CutLength), write('\n'),    % DEBUG
    RealFlankLength > CutLength.

check_segment(Position, Direction, State, State, _):-
    write('Wtf am I doing here?\n').

check_segment_s1(Position, Direction, State, NewState, FlankLength, CutLength):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    perpendicular(Direction, Perpendicular),
    % write('Perpendicular: '), write(Perpendicular), write('\n'),    % DEBUG
    count_cut_s0(NewPosition, Perpendicular, State, Count),
    write(Position), write(' -> cut size: '), write(Count), write('\n'),    % DEBUG
    check_segment_s2(NewPosition, Direction, State, S1, FL, CL),
    write('Max('), write(Count), write(', '), write(CL), write(') = '),     % DEBUG
    max(Count, CL, CutLength),
    write(CutLength), write('\n'),                                        % DEBUG
    write('NewPosition: '), write(NewPosition), write('\n'),                % DEBUG
    update_board(S1, NewPosition, NewState),
    FlankLength is FL + 1.


check_segment_s2(Position, Direction, State, NewState, FlankLength, CutLength):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    perpendicular(Direction, Perpendicular),
    % write('Perpendicular: '), write(Perpendicular), write('\n'),    % DEBUG
    count_cut_s0(NewPosition, Perpendicular, State, Count),
    write(Position), write(' -> cut size: '), write(Count), write('\n'),    % DEBUG
    check_segment_s2(NewPosition, Direction, State, S1, FL, CL),
    write('Max('), write(Count), write(', '), write(CL), write(') = '),     % DEBUG
    max(Count, CL, CutLength),
    write(CutLength), write('\n'),                                        % DEBUG
    write('NewPosition: '), write(NewPosition), write('\n'),                % DEBUG
    update_board(S1, NewPosition, NewState),
    FlankLength is FL + 1.


check_segment_s2(Position, Direction, State, State, 2, 0):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, CurrentPlayer).

% check_segment_s2(Position, Direction, State, State, 0, 0).
% check_segment_s1(Position, Direction, State, State, 0, 0).



% check_segment(Position, Direction, State, State, 0, _).

% check_segment(Position, Direction, State, NewState, 0, FlankLength, CutLength):-
%     write('A: check_segment('), write(Position), write(', '), write(Direction), write(', '), write(State), write(', '), write(NewState), write(', '), write(0), write(', '), write(FlankLength), write(', '), write(CutLength), write(')\n'),
%     game_state_pack(State, Board, CurrentPlayer, Opponent),
%     mx_delta(Position, Direction, NewPosition),
%     mx_get(NewPosition, Board, Piece),
%     Piece == Opponent,
%     perpendicular(Direction, Perpendicular),
%     count_cut(NewPosition, Perpendicular, State, Count),
%     check_segment(NewPosition, Direction, State, S1, 1, FL, CL),
%     max(Count, CL, CutLength),
%     update_board(S1, NewPosition, NewState),
%     FlankLength is FL + 1.

% check_segment(Position, Direction, State, State, 0, 0, 0):-
%     write('B: check_segment('), write(Position), write(', '), write(Direction), write(', '), write(State), write(', '), write(State), write(', '), write(0), write(', '), write(0), write(', '), write(0), write(')\n').

% check_segment(Position, Direction, State, State, 1, 0, 0):-
%     write('E: check_segment('), write(Position), write(', '), write(Direction), write(', '), write(State), write(', '), write(State), write(', '), write(1), write(', '), write(FL), write(', '), write(BL), write(')\n').
%     game_state_pack(State, Board, CurrentPlayer, Opponent),
%     mx_delta(Position, Direction, NewPosition),
%     mx_get(NewPosition, Board, ' ').

% check_segment(Position, Direction, State, State, 1, 2, 0):-
%     write('D: check_segment('), write(Position), write(', '), write(Direction), write(', '), write(State), write(', '), write(State), write(', '), write(1), write(', '), write(2), write(', '), write(0), write(')\n'),
%     game_state_pack(State, Board, CurrentPlayer, Opponent),
%     mx_delta(Position, Direction, NewPosition),
%     mx_get(NewPosition, Board, Piece),
%     Piece == CurrentPlayer,
%     !.
    
% check_segment(Position, Direction, State, NewState, 1, FlankLength, CutLength):-
%     write('C: check_segment('), write(Position), write(', '), write(Direction), write(', '), write(State), write(', '), write(NewState), write(', '), write(1), write(', '), write(FlankLength), write(', '), write(CutLength), write(')\n'),
%     game_state_pack(State, Board, CurrentPlayer, Opponent),
%     mx_delta(Position, Direction, NewPosition),
%     mx_get(NewPosition, Board, Piece),
%     Piece == Opponent,
%     perpendicular(Direction, Perpendicular),
%     count_cut(NewPosition, Perpendicular, State, Count),
%     check_segment(NewPosition, Direction, State, S1, 1, FL, CL),
%     max(Count, CL, CutLength),
%     update_board(S1, NewPosition, NewState),
%     FlankLength is FL + 1,
%     !.
    
% ------------------------------------------------------------------------------- COUNT CUT
count_cut_s0(Position, Direction1-Direction2, State, Cut):-
    write('Checking cut for '), write(Position), write('\n'),    % DEBUG
    write('Directions: '), write(Direction1), write(' '), write(Direction2), write('\n'),    % DEBUG
    count_cut_s1(Position, Direction1, State, Cut1),
    write('Cut1: '), write(Cut1), write('\n'),          % DEBUG
    count_cut_s1(Position, Direction2, State, Cut2),
    write('Cut2: '), write(Cut2), write('\n'),          % DEBUG
    Cut is Cut1 + Cut2 + 1.

% count_cut(Position, vertical, State, Count):-
%     count_cut(Position, up, State, CountUp),
%     count_cut(Position, down, State, CountDown),
%     Count is CountUp + CountDown + 1.

% count_cut(Position, horizontal, State, Count):-
%     count_cut(Position, left, State, CountLeft),
%     count_cut(Position, right, State, CountRight),
%     Count is CountLeft + CountRight + 1.

count_cut_s1(Position, Direction, State, Count):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Opponent),
    count_cut_s1(NewPosition, Direction, State, Count1),
    Count is Count1 + 1,
    !.

count_cut_s1(Position, Direction, State, 0):- !.

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

winning_condition(State):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    % Aqui tive de por a checkar a condição da vitoria para o oponent porque já se mudou o current player antes deste predicado
    % Mesmo assim so reconhece a vitoria passadas algumas rondas
    (check_rows(Opponent, Board);
    check_columns(Opponent, Board)).
    

% ------------------------------------------------------ CHECK ROWS
/**
 * check_rows(+CurrentPlayer, +Board)
 */
check_rows(CurrentPlayer, [H]):-
    check_full_row(CurrentPlayer, H, 0).
check_rows(CurrentPlayer, [H|B]):-
    check_full_row(CurrentPlayer, H, 0); check_rows(CurrentPlayer, B).
/**
 * check_full_row(+CurrentPlayer, +Row, +State)
 */
check_full_row(CurrentPlayer, [_|B], 0):-
    check_full_row(CurrentPlayer, B, 1).
check_full_row(CurrentPlayer, [H|B], 1):-
    H == CurrentPlayer,
    check_full_row(CurrentPlayer, B, 1).
check_full_row(_, [_], 1).


% ------------------------------------------------------ CHECK COLUMNS
/**
 * check_columns(+CurrentPlayer, +Board)
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

/**
 * check_full_column(+CurrentPlayer, +Board, +Col)
 */
check_full_column(CurrentPlayer, Board, Col):-
    length(Board, N),
    N1 is N - 1,
    check_full_column(CurrentPlayer, Board, 1, Col, N1).

check_full_column(_, _, N, _, N).

check_full_column(CurrentPlayer, Board, Row, Col, N):-
    mx_get(Row-Col, Board, CurrentPlayer),
    NewRow is Row + 1,
    check_full_column(CurrentPlayer, Board, NewRow, Col, N).

    
