% get_int(INT) :-
%     write('Insert the int to be read: '), 
%     read(INPUT),
%     get_int(INPUT, 0).

% get_int([ ], _) :- !.
% get_int([H | STR], INT) :-
%     ASCII is char_code(H, INT) - 48,
%     NEW_INT is INT * 10 + ASCII,
%     get_int(STR, NEW_INT).

% ------------------------------------------------------ PRINT BOARD

print_separator_line(1) :-
    write('\e[97m-----\e[0m'),
    nl,
    !.
print_separator_line(N) :-
    N1 is N - 1,
    write('\e[97m----\e[0m'),
    print_separator_line(N1).

print_line(LINE) :-
    length(LINE, N),
    print_line(N, 1, LINE).
print_line(_, _, []) :- 
    write('\e[97m|\e[0m'),
    nl,
    !.
print_line(N, X, [FELEMENT | REST]) :-
    X =< N,
    X1 is X + 1,
    write('\e[97m| \e[0m'),
    display_piece(FELEMENT),
    write(' '),
    print_line(N, X1, REST).

print_board(BOARD) :-
    length(BOARD, N),
    print_board(N, 1, BOARD).
print_board(N, Y, []) :-
    print_separator_line(N), nl.
print_board(N, Y, [FLINE | REST]) :-
    Y =< N,
    Y1 is Y + 1,
    print_separator_line(N),
    print_line(FLINE),
    print_board(N, Y1, REST).

% ------------------------------------------------------ CLEAR SCREEN    
cls :- write('\33\[2J').

% ------------------------------------------------------ DISPLAY PIECE
display_piece(' ') :- write(' ').
display_piece('1') :- write('\e[91mO\e[0m').
display_piece('2') :- write('\e[94mO\e[0m').