% ------------------------------------------------------ GET INT

get_int(N):- 
    get_int(0, N).

get_int(N, Bottom, Top):-
    get_int(0, Input),
    (between(Bottom, Top, Input) -> N = Input; get_int(N, Top, Bottom)).

get_int(N, N):- 
    peek_code(10), 
    get_code(10), 
    !.
    
get_int(Current, Result):-
    get_code(Input),
    between(48, 57, Input),
    New is Current * 10 + (Input - 48),
    get_int(New, Result).


% ------------------------------------------------------ READ INPUT

read_column(Size, Column) :-
    write('\e[91m Column: \e[0m'),
    get_int(Input),
    (Input > 0, Input =< Size -> Column = Input; read_column(Size, Column)).

read_row(Size, Row) :-
    write('\e[94m    Row: \e[0m'),
    get_int(Input),
    (Input > 0, Input =< Size -> Row = Input; read_row(Size, Row)).

read_move(Size, Move) :-
    read_row(Size, Row),
    read_column(Size, Column),
    Move = (Row-Column).

% ------------------------------------------------------ DISPLAY GAME

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

print_line(Line):-
    length(Line, N),
    print_line(N, 0, Line).
print_line(_, _, []) :- 
    write('\e[97m|\e[0m'),
    nl,
    !.
print_line(N, X, [FirstElement | Rest]):-
    X =< N,
    X1 is X + 1,
    write('\e[97m| \e[0m'),
    display_piece(FirstElement),
    write(' '),
    print_line(N, X1, Rest).

display_game(State):-
    length(State, N),
    print_top_indexes(N),
    display_game(N, 0, State).
display_game(N, Y, []):-
    print_separator_line(N), nl.
display_game(N, Y, [FirstLine | Rest]):-
    Y =< N,
    Y1 is Y + 1,
    print_separator_line(N),
    print_side_index(Y),
    print_line(FirstLine),
    display_game(N, Y1, Rest).

% ------------------------------------------------------ CLEAR SCREEN    
cls :- write('\33\[2J').

% ------------------------------------------------------ DISPLAY PIECE
display_piece(' '):- write(' ').
display_piece('1'):- write('\e[91mO\e[0m').
display_piece('2'):- write('\e[94mO\e[0m').