% ----------------------------------------------------- INITIAL
initial(Size, InitialState):-
    create_board(Size, ' ', Board),
    game_state_pack(InitialState, Board, '1', '2').

% ----------------------------------------------------- FINAL
final(State):- 
    game_over(State, Winner).

% ----------------------------------------------------- MOVE
move(State, NewState):-
    valid_move(State, NewState).

% ----------------------------------------------------- PLAY
play:- 
    write('Size of board: '), nl,
    get_int(Size, 5, 10), 
    initial(Size, Init),
    play(Init, [Init], States),
    reverse(States, Path), write(Path).

play(Curr, Path, Path):- 
    game_state_pack(Curr, Board, Player1, Player2),
    % trace,      % TODO: remove
    final(Curr), 
    display_game(Board),
    !.

play(Curr, Path, States):- 
    % notrace,      % TODO: remove
    game_state_pack(Curr, Board, Player1, Player2),
    display_game(Board),
    move(Curr, S1),
    switch_current_player(S1, Next),
    not( member(Next, Path) ),
    play(Next, [Next|Path], States).

 

