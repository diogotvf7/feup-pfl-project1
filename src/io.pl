% ------------------------------------------------------ READ INPUT

get_x(X, Limit):-
    X < LIMIT,
    X > 0,
    !.
get_x(X, Limit):-
    write('\e[91m Column: \e[0m'),
    get_char(X), skip_line,
    get_x(X, Limit).

get_y(Y, Limit):-
    write('\e[94m    Row: \e[0m'),
    get_char(Y), skip_line.

read_move(MOVE, LIMIT):-
    get_x(X).
    MOVE = (X-Y).

% ------------------------------------------------------ PRINT BOARD

print_top_indexes(N):-
    write('     '),
    N1 is N-1,
    print_top_indexes(N1, 0).
print_top_indexes(N, N):-
    write('\e[91m'),
    write(N),
    write('\e[0m'),
    nl,
    !.
print_top_indexes(N, I):-
    I =< N,
    I1 is I + 1,
    write('\e[91m'),
    write(I),
    write('   \e[0m'),
    print_top_indexes(N, I1).

print_side_index(N):-
    write('\e[94m '),
    write(N),
    write(' \e[0m').

print_separator_line(N):-
    write('   '),
    print_separator_line(N, 1).
print_separator_line(N, N) :-
    write('\e[97m-----\e[0m'),
    nl,
    !.
print_separator_line(N, I):-
    I =< N,
    I1 is I + 1,
    write('\e[97m----\e[0m'),
    print_separator_line(N, I1).

print_line(LINE):-
    length(LINE, N),
    print_line(N, 0, LINE).
print_line(_, _, []) :- 
    write('\e[97m|\e[0m'),
    nl,
    !.
print_line(N, X, [FELEMENT | REST]):-
    X =< N,
    X1 is X + 1,
    write('\e[97m| \e[0m'),
    display_piece(FELEMENT),
    write(' '),
    print_line(N, X1, REST).

print_board(BOARD):-
    length(BOARD, N),
    print_top_indexes(N),
    print_board(N, 0, BOARD).
print_board(N, Y, []):-
    print_separator_line(N), nl.
print_board(N, Y, [FLINE | REST]):-
    Y =< N,
    Y1 is Y + 1,
    print_separator_line(N),
    print_side_index(Y),
    print_line(FLINE),
    print_board(N, Y1, REST).

% ------------------------------------------------------ CLEAR SCREEN    
cls :- write('\33\[2J').

% ------------------------------------------------------ DISPLAY PIECE
display_piece(' '):- write(' ').
display_piece('1'):- write('\e[91mO\e[0m').
display_piece('2'):- write('\e[94mO\e[0m').