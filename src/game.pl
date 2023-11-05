% ----------------------------------------------------- INITIAL
initial_state([Player1, Player2, Size, Difficulty], InitialState):-
    create_board(Size, Board),
    game_state_pack(InitialState, Board, Player1, Player2, Difficulty).

% ----------------------------------------------------- FINAL
final(State):- 
    game_over(State, Winner),
    game_state_pack(State, Board, CurrentPlayer, _, _),
    winner_menu(Board, Winner).

% ----------------------------------------------------- MOVE
move(State, NewState):-
    valid_move(State, NewState).

% ----------------------------------------------------- PLAY
play:- 
    main_menu(Input),
    (
        Input == 1 -> (
            play_menu(Config),      
            initial_state(Config, Init),
            play(Init, [Init], States),
            reverse(States, Path), write(Path),      
            play
        );
        Input == 2 ->(
            rules_menu,
            play
        );
        Input == 3 ->(
            exit_menu(Exit_Input),
            Exit_Input == 2 -> play ; cls, halt
        )
    ).

play(Curr, Path, Path):- 
    final(Curr), 
    !.

play(Curr, Path, States):- 
    game_state_pack(Curr, Board, CurrentPlayer, Opponent, Difficulty),
    display_game(Board),
    move(Curr, S1),
    switch_current_player(S1, Next),
    cls,
    not( member(Next, Path) ),
    play(Next, [Next|Path], States).

 

