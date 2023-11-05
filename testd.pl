% :- use_module(library(between)).
:- use_module(library(lists)).
:- ['src/util.pl'].
:- ['src/game_logic.pl'].
% :- ['src/io.pl'].
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

best_move(State, BestState, Depth):-
    game_state_pack(State, Board, Max, _, _),
    depth_value(Max, State, BestState, _, Depth).

depth_value(_, State, _, Val, 0):-
    % notrace, % DEBUG
    value(State, Val), !
    % trace, % DEBUG
    write(Val), nl.

depth_value(Max, State, BestState, Val, Depth):-
    % notrace, % DEBUG
    valid_moves(State, ListOfMoves), !,             
    write('Depth: '), write(Depth), nl,
    write('ListOfMoves: '), write(ListOfMoves), nl,
    % trace, % DEBUG
    best_move(Max, State, ListOfMoves, BestState, Val, Depth).

best_move(Max, State, [Move], BestState, Val, Depth):-
    % notrace, % DEBUG
    valid_move(Move, State, NewState),
    % trace, % DEBUG
    depth_value(Max, NewState, _, Val, Depth),
    !.

best_move(Max, State, [Move|B], BestState, BestVal, Depth):-
    Depth1 is Depth - 1,
    % notrace, % DEBUG
    valid_move(Move, State, State1),
    % trace, % DEBUG
    depth_value(Max, State1, _, Val1, Depth1),
    best_move(Max, State, B, State2, Val2, Depth),
    compare_state(Max, State1, Val1, State2, Val2, BestState, BestVal).

compare_state(Max, State1, Val1, State2, Val2, BestState, BestVal):-
    game_state_pack(State1, _, CurrentPlayer, _, _),
    CurrentPlayer \== Max, Val1 > Val2, !;
    CurrentPlayer == Max, Val1 < Val2, !.

compare_state(_, _, State2, Val2, State2, Val2).

% -------------------------------------------------------------------------------


:-  
    % prompt(_, 'ASDASD'),
    % read(FirstLine).
    State = [[[' ',  ' ',  ' ',  ' ',  ' '],
              [' ',  'p1', 'p1', ' ',  ' '],
              [' ',  ' ',  ' ',  ' ',  ' '],
              [' ',  ' ',  'p2', 'p2', ' '],
              [' ',  ' ',  ' ',  ' ',  ' '] 
             ], 'p1', 'p2', 1],

            
    % valid_moves(State, ListOfMoves),
    % write('List of moves: '), write(ListOfMoves), nl.
    
    best_move(State, BestState, 1),
    write('Best state: '), write(BestState), nl.

    % Board = [[' ',  ' ',  ' ',  ' ',  ' ',  ' ' ],
    %          [' ',  'p1', ' ',  'p1', 'p1', ' ' ],
    %          [' ',  'p1', ' ',  'p1', ' ',  ' ' ],
    %          ['p1', 'p1', ' ',  'p1', 'p1', 'p1'],
    %          [' ',  ' ',  ' ',  'p1', 'p1', ' ' ],
    %          [' ',  ' ',  ' ',  'p1', ' ',  ' ' ]
    %         ],
    % get_largest_segment(Board, 'p1', Max),
    % write('Max: '), write(Max), nl.


    % write('\e[90m black \e[0m'), nl,
    % write('\e[91m red \e[0m'), nl,
    % write('\e[92m green \e[0m'), nl,
    % write('\e[93m yellow \e[0m'), nl,
    % write('\e[94m blue \e[0m'), nl,
    % write('\e[95m magenta \e[0m'), nl,
    % write('\e[96m cyan \e[0m'), nl,
    % write('\e[97m white \e[0m').
    
% -------------------------------------------------------------------------------
