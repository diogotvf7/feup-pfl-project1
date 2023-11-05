% :- use_module(library(between)).
:- use_module(library(lists)).
:- ['src/util.pl'].
% :- ['src/game_logic.pl'].
% :- ['src/io.pl'].
% :- ['src/board.pl'].


% -------------------------------------------------------------------------------

%  ╭ ─ ╮ ┬  ╰ ─ ╯ ┴  │ ┤ ├ ┼ ● ○ 
%  
% ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭─╮   ╭─╮  ╭───────╮
% │ ╭───╮ │  │  ╭─╮  │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ │   │ │  ╰──╮ ╭──╯
% │ │   │ │  │  ╰─╯  │  │ │   │ │  │ │   ╰─╯  │ │   ╰─╯  │ │   │ │  │ │   │ │     │ │   
% │ │   ╰─╯  │ ╭─╮ ╭─╯  │ │   │ │  │ ╰─────╮  │ ╰─────╮  │ │   ╰─╯  │ │   │ │     │ │   
% │ │   ╭─╮  │ │ │ │    │ │   │ │  ╰─────╮ │  ╰─────╮ │  │ │   ╭─╮  │ │   │ │     │ │   
% │ │   │ │  │ │ │ │    │ │   │ │  ╭─╮   │ │  ╭─╮   │ │  │ │   │ │  │ │   │ │     │ │   
% │ ╰───╯ │  │ │ │ │    │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │     │ │   
% ╰───────╯  ╰─╯ ╰─╯    ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯     ╰─╯   
% -------------------------------------------------------------------------------


get_largest_segment(Board, Player, Max):-
    get_largest_segment_s0(Board, Player, 0-0, Max).

get_largest_segment_s0(Board, Player, Position, Max):-
    mx_valid_position(Board, Position),
    get_largest_segment_s1(Board, Player, Position, Max1),
    NewRow is (Row + 1) mod N,
    (NewRow == 0 -> NewCol is Col + 1; NewCol is Col),
    get_largest_segment_s0(Board, Player, NewRow-NewCol, Max2),
    max(Max1, Max2, Max).


get_largest_segment_s1(Board, Player, Position, Max):-
    mx_get(Position, Board, Player),
    get_largest_segment_s2(Board, Player, Position, up, SizeUp),
    get_largest_segment_s2(Board, Player, Position, down, SizeDown),
    get_largest_segment_s2(Board, Player, Position, left, SizeLeft),
    get_largest_segment_s2(Board, Player, Position, right, SizeRight),
    lmax([SizeUp, SizeDown, SizeLeft, SizeRight], Max).

get_largest_segment_s2(Board, Player, Position, Direction, Size):-
    mx_delta(Position, Direction, NewPosition),
    mx_valid_position(Board, NewPosition),
    mx_get(NewPosition, Board, Player),
    get_largest_segment_s2(Board, Player, NewPosition, Direction, Curr),
    Size is Curr + 1.

get_largest_segment_s2(Board, Player, Position, Direction, 1).


% -------------------------------------------------------------------------------

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


% count_pieces_s0([Row | RoBoard], Player, Row-Col, Total):-
%     count_pieces_s1(Row, Player, Row-0, PiecesRow),
%     NewRow is Row+1,
%     count_pieces_s0(RoBoard, Player, NewRow-0,RoBPieces),
%     Total is PiecesRow + RoBPieces.

% count_pieces_s0([],_,_,0)

% count_pieces_s1([Piece | RoRow], Player, Row-Col, Count):-
%     (Piece = Player -> PCount = 1; PCount = 0),
%     NewCol is Col+1,
%     count_pieces_s1(RoRow, Player, Row-NewCol, RoRCount),
%     Count is PCount + RoRCount.

% count_pieces_s1([],_,_,0)


:-  
    % prompt(_, 'ASDASD'),
    % read(FirstLine).

    % Board = [['  ', '  ', '  ', 'p1', '  ', '  '],
    %          ['  ', 'p1', 'p1', '  ', 'p1', '  '],
    %          ['  ', 'p1', '  ', '  ', '  ', '  '],
    %          ['  ', 'p1', 'p1', 'p1', 'p1', 'p1'],
    %          ['  ', '  ', '  ', '  ', '  ', '  '],
    %          ['  ', '  ', '  ', '  ', 'p1', '  ']].
    Board = [['  ', '  ', '  ', 'p1', '  ', '  '],
             ['  ', 'p2', 'p2', '  ', 'p2', '  '],
             ['  ', 'p2', '  ', '  ', '  ', '  '],
             ['  ', 'p1', 'p1', 'p1', 'p1', 'p1'],
             ['  ', '  ', '  ', '  ', '  ', '  '],
             ['  ', '  ', '  ', '  ', 'p2', '  ']],

    count_pieces(Board, 'p1', Count),
    write('Count: '), write(Count), nl.
    % write('\e[90m black \e[0m'), nl,
    % write('\e[91m red \e[0m'), nl,
    % write('\e[92m green \e[0m'), nl,
    % write('\e[93m yellow \e[0m'), nl,
    % write('\e[94m blue \e[0m'), nl,
    % write('\e[95m magenta \e[0m'), nl,
    % write('\e[96m cyan \e[0m'), nl,
    % write('\e[97m white \e[0m').
    
% -------------------------------------------------------------------------------
