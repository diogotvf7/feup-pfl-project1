:- ['util.pl'].
:- ['board.pl'].
:- ['game_logic.pl'].

% ----------------------------------------------------- INITIAL
initial(Size, InitialState):-
    create_board(Size, ' ', Board),
    game_state_pack(InitialState, Board, '1', '2').

% ----------------------------------------------------- FINAL
final(State):- 
    winning_condition(State).

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
    final(Curr), !.

play(Curr, Path, States):- 
    game_state_pack(Curr, Board, Player1, Player2),
    notrace,                        % <--- REMOVE THIS
    display_game(Board),
    move(Curr, Next),
    not( member(Next, Path) ),
    play(Next, [Next|Path], States).





    % ___
    % |    read_move(player, move)
    % |    check(move)
    % if true
    % |    update(move, board, )
    % else go read_move







% % -----------------------------------------------------
% % MISC

% cls :- write('\33\[2J').

% % BOARD_LINE

% ask_question( [QUESTION], ANSWER) :-
%     write(QUESTION), nl,
%     get_char(ANSWER), skip_line.
% ask_question( [HEAD | QUESTION], ANSWER) :-
%     write(HEAD), nl,
%     ask_question(QUESTION, ANSWER).
    

