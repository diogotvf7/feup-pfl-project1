:- use_module(library(between)).
:- use_module(library(lists)).
:- ['src/util.pl'].
:- ['src/game_logic.pl'].
:- ['src/io.pl'].
:- ['src/board.pl'].


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



:-  
    Board = [
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' '],
        [' ',  ' ',  'p1', 'p2', ' ',  ' ',  ' ',  ' ',  ' ',  ' '],
        [' ',  ' ',  'p2', 'p1', ' ',  ' ',  ' ',  ' ',  ' ',  ' '],
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'p2', ' ',  ' '],
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'p1', ' ',  ' '],
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'p2', 'p1', ' ',  ' '],
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'p1', 'p2', ' ',  ' '],
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' '],
        [' ',  ' ',  'p2', 'p1', ' ',  ' ',  ' ',  ' ',  ' ',  ' '],
        [' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ']
    ],
    game_state_pack(State, Board, p1, p2, easy),
    write('State: '), write(State), nl,
    valid_moves(State, ListOfMoves),
    display_game(Board),
    write(ListOfMoves).

    % write('\e[90m black \e[0m'), nl,
    % write('\e[91m red \e[0m'), nl,
    % write('\e[92m green \e[0m'), nl,
    % write('\e[93m yellow \e[0m'), nl,
    % write('\e[94m blue \e[0m'), nl,
    % write('\e[95m magenta \e[0m'), nl,
    % write('\e[96m cyan \e[0m'), nl,
    % write('\e[97m white \e[0m').
    
% -------------------------------------------------------------------------------
