% ----------------------------------------------------- INITIAL
initial(InitialState).

% ----------------------------------------------------- FINAL
final(State):- 
    winning_condition(State).

% ----------------------------------------------------- MOVE
move(State, NewState):-
    valid_move(State, NewState),

% ----------------------------------------------------- PLAY
play:- 
    initial(Init),
    play(Init, [Init], States),
    reverse(States, Path), write(Path).

play(Curr, Path, Path):- 
    final(Curr), !.

play(Curr, Path, States):- 
    move(Curr, Next),
    not( member(Next, Path) ),
    play(Next, [Next|Path], States).





    % ___
    % |    read_move(player, move)
    % |    check(move)
    % if true
    % |    update(move, board, )
    % else go read_move









% play :-
%     % cls,
%     % ask_question(['Choose your mode:', 
%     %             '     1. Human      x      Human',
%     %             '     2. Human      x      Computer',
%     %             '     3. Computer   x      Human',
%     %             '     4. Computer   x      Computer',
%     %             ],
%     %             MODE),
%     % cls,
%     % ask_question(['Choose the size of the board:',
%     %             '     1. 8x8',
%     %             '     2. 9x9',
%     %             '     3. 10x10'],
%     %             SIZE),
%     % cls,
%     build_board_line_1(BL, 3),
%     write(BL),
%     get_char(_).


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
    

