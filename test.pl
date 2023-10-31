% :- use_module(library(between)).
:- use_module(library(lists)).
:- ['src/util.pl'].
:- ['src/io.pl'].

% -------------------------------------------------------------------------------
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
    

% -------------------------------------------------------------------------------


% ------------------------------------------------------------------------------- CHECK FLANKING
check_flanking(Start, State, NewState):-
    check_segment(Start, up, State, S1, 0),
    check_segment(Start, down, S1, S2, 0),
    check_segment(Start, left, S2, S3, 0),
    check_segment(Start, right, S3, NewState, 0).

% ------------------------------------------------------------------------------- CHECK SEGMENT
check_segment(Position, Direction, State, NewState, 0):-
%     trace,
    check_segment(Position, Direction, State, NewState, 0, FlankLength),
    write('Segment length: '), write(FlankLength), nl
    .

check_segment(Position, Direction, State, NewState, 0, FlankLength):-
% check_segment(Position, Direction, State, NewState, 0):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == Opponent,
    perpendicular(Direction, Perpendicular),                % <--- CHECK
    count_cut(NewPosition, Perpendicular, State, Count),    % <--- CHECK
    check_segment(NewPosition, Direction, State, S1, 1, FL),
    % check_segment(NewPosition, Direction, State, S1, 1),
    update_board(S1, NewPosition, NewState),
    FlankLength is FL + 1.

check_segment(Position, Direction, State, State, 0, 0).
% check_segment(Position, Direction, State, State, 0).

check_segment(Position, Direction, State, NewState, 1, FlankLength):-
% check_segment(Position, Direction, State, NewState, 1):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == Opponent,
    perpendicular(Direction, Perpendicular),                % <--- CHECK
    count_cut(NewPosition, Perpendicular, State, Count),    % <--- CHECK
    check_segment(NewPosition, Direction, State, S1, 1, FL),
    % check_segment(NewPosition, Direction, State, S1, 1),
    update_board(S1, NewPosition, NewState),
    FlankLength is FL + 1.

check_segment(Position, Direction, State, State, 1, 2):-
% check_segment(Position, Direction, State, State, 1):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    mx_delta(Position, Direction, NewPosition),
    mx_get(NewPosition, Board, Piece),
    Piece == CurrentPlayer.
    % FlankLength = 1.
    
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

% count_cut(Position, vertical, State, Count):-
%     game_state_pack(State, Board, CurrentPlayer, Opponent),
%     mx_delta(Position, up, NewPosition),
%     mx_get(NewPosition, Board, Piece),
%     Piece == Opponent,
%     count_cut(NewPosition, vertical, State, Count1),
%     Count is Count1 + 1.

% count_cut(Position, horizontal, State, Count):-

% -------------------------------------------------------------------------------

:-
    Board = [
             [' ', ' ', '2', ' ', ' ', ' '],
             [' ', '1', '2', '2', '1', ' '],
             [' ', ' ', '2', ' ', ' ', ' '],
             [' ', ' ', '2', ' ', ' ', ' '],
             [' ', ' ', '2', ' ', ' ', ' '],
             [' ', ' ', ' ', ' ', ' ', ' ']
            ], 
    game_state_pack(State, Board, '1', '2'),
    display_game(Board),
    % trace,
    check_flanking(1-1, State, NewState),
    game_state_pack(NewState, NewBoard, '1', '2'),
    nl, nl, nl,
    display_game(NewBoard).

% -------------------------------------------------------------------------------

% :-
%     Board = [
%              [' ', ' ', ' ', ' ', ' ', ' '],
%              ['1', '2', '2', '1', ' ', ' '],
%              ['2', ' ', ' ', ' ', ' ', ' '],
%              ['2', ' ', ' ', ' ', ' ', ' '],
%              ['2', ' ', ' ', ' ', ' ', ' '],
%              ['1', ' ', ' ', ' ', ' ', ' ']
%             ], 
%     game_state_pack(State, Board, '1', '2'),
%     display_game(Board),
%     % trace,
%     check_flanking(1-0, State, NewState),
%     game_state_pack(NewState, NewBoard, '1', '2'),
%     nl, nl, nl,
%     display_game(NewBoard).

% -------------------------------------------------------------------------------
