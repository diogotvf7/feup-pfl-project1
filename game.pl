play :-
    cls,
    ask_question(['Choose your mode:', 
                '     1. Human      x      Human', 
                '     2. Human      x      Computer', 
                '     3. Computer   x      Human'], 
                MODE),
    cls,
    ask_question(['Choose the size of the board:', 
                '     1. 8x8', 
                '     2. 9x9', 
                '     3. 10x10'], 
                SIZE),

    write(MODE),
    write(SIZE),
    cls,
    build_board_line_1(BL, 3),
    write(BL).


% ___________________________________________
% MISC

cls :- write('\33\[2J').
cls :- write('\33\[2J').

% ___________________________________________
% I/O

ask_question( [QUESTION], ANSWER) :-
    write(QUESTION), nl,
    get_char(ANSWER), skip_line.
ask_question( [HEAD | QUESTION], ANSWER) :-
    write(HEAD), nl,
    ask_question(QUESTION, ANSWER).
    
% ___________________________________________
% BUILDING BOARD

    % build_board(SIZE, BOARD) :-
    %     build_board(SIZE, BOARD, BOARD).
    % build_board(SIZE, BOARD, 1) :-
    % build_board(SIZE, BOARD, N) :-

build_board_line_1(BOARD_LINE, 0) :-
    BOARD_LINE = ''.
build_board_line_1(BOARD_LINE, N) :-
    N > 0,
    N1 is N - 1,
    build_board_line_1(['___' | BOARD_LINE], N1).

