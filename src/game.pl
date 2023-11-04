% ----------------------------------------------------- INITIAL
initial_state(Player1-Player2-Difficulty-Size, InitialState):-
    create_board(Size, Board),
    game_state_pack(InitialState, Board, Player1, Player2, Difficulty).

% ----------------------------------------------------- FINAL
final(State):- 
    game_over(State, Winner).

% ----------------------------------------------------- MOVE
move(State, NewState):-
    valid_move(State, NewState).

% ----------------------------------------------------- PLAY
play:- 
    % main_menu(Input),
    % (
    %     Input == 1 -> play_menu(Config);
    % ),
    write('Size of board: '), nl,
    get_int(Size, 5, 10), 
    % trace,
    initial_state(p1-p2-easy-Size, Init),
    play(Init, [Init], States),
    reverse(States, Path), write(Path),
    play.

play(Curr, Path, Path):- 
    game_state_pack(Curr, Board, CurrentPlayer, Opponent, Difficulty),
    final(Curr), 
    display_game(Board),
    !.

play(Curr, Path, States):- 
    game_state_pack(Curr, Board, CurrentPlayer, Opponent, Difficulty),
    display_game(Board),
    move(Curr, S1),
    switch_current_player(S1, Next),
    not( member(Next, Path) ),
    play(Next, [Next|Path], States).

 

