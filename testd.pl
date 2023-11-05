% :- use_module(library(between)).
:- use_module(library(lists)).
:- ['src/util.pl'].
:- ['src/game_logic.pl'].
% :- ['src/io.pl'].
:- ['src/board.pl'].


% -------------------------------------------------------------------------------

best_move(State, BestMove, Depth):-
    game_state_pack(State, Board, Max, _, _),
    switch_current_player(State, StartState),
    depth_value(Max, StartState, BestMove, _, Depth).

depth_value(_, State, _, Val, 0):-
    % notrace, % DEBUG1
    value(State, Val), !.
    % write('Val: '), write(Val), nl. % DEBUG2
    % trace. % DEBUG1
    % write(Val), nl.

depth_value(Max, State, BestMove, Val, Depth):-
    % notrace, % DEBUG1
    Depth1 is Depth - 1,
    switch_current_player(State, NewState),  
    valid_moves(NewState, ListOfMoves), !,    
    write('Depth: '), write(Depth), write('  |  NewState: '), write(NewState), nl,
    write('             ListOfMoves: '), write(ListOfMoves), nl, % DEBUG2
    % write('Depth: '), write(Depth), nl, % DEBUG2
    % trace, % DEBUG1
    best_move(Max, NewState, ListOfMoves, BestMove, Val, Depth1);
    value(State, Val).

best_move(Max, State, [Move], Move, Val, Depth):-
    % notrace, % DEBUG1
    valid_move(Move, State, NewState),
    % trace, % DEBUG1
    depth_value(Max, NewState, _, Val, Depth),
    !.

best_move(Max, State, [Move1|B], BestMove, BestVal, Depth):-
    % notrace, % DEBUG1
    valid_move(Move1, State, NewState),
    % trace, % DEBUG1
    depth_value(Max, NewState, _, Val1, Depth1),
    best_move(Max, State, B, Move2, Val2, Depth),
    write('\nDepth: '), write(Depth), nl, % DEBUG2
    compare_state(Max, NewState, Move1, Val1, Move2, Val2, BestMove, BestVal).
    % write('BestState: '), write(BestState), nl, % DEBUG2
    % write('BestVal: '), write(BestVal), nl. % DEBUG2

compare_state(Max, State, Move1, Val1, Move2, Val2, Move1, Val1):-
    write('State: '), write(State), nl, % DEBUG2
    write('Move1: '), write(Move1), write('   - Val1: '), write(Val1), nl, % DEBUG2
    write('Move2: '), write(Move2), write('   - Val2: '), write(Val2), nl, % DEBUG2
    game_state_pack(State, _, CurrentPlayer, _, _),
    write('CurrentPlayer: '), write(CurrentPlayer), nl, % DEBUG2
    write('Max: '), write(Max), nl, % DEBUG2
    (
        CurrentPlayer \== Max, Val1 < Val2, !;
        CurrentPlayer == Max, Val1 > Val2, !
    ).

compare_state(Max, _, _, _, Move2, Val2, Move2, Val2):- write('Chose Move 2'), nl.

% -------------------------------------------------------------------------------


:-  
    % prompt(_, 'ASDASD'),
    % read(FirstLine).
    State = [[[' ',  ' ',  ' ',  ' ',   ' ', ' '],
              [' ',  'p1', 'p1', 'p1',  ' ', ' '],
              [' ',  'p1', ' ',  ' ',   ' ', ' '],
              [' ',  'p1',  'p2', ' ',   ' ', ' '],
              [' ',  ' ',  'p2', ' ',   ' ', ' '],
              [' ',  ' ',  ' ',  ' ',   ' ', ' '] 
             ], 'p1', 'p2', 1],

    best_move(State, BestState, 6),
    write('Best move: '), write(BestState), nl.

    
% -------------------------------------------------------------------------------
