% ------------------------------------------------------ GET INT

get_int(N):- 
    get_int(0, N).

get_int(N, Bottom, Top):-
    get_int(0, Input),
    (between(Bottom, Top, Input) -> N = Input; get_int(N, Bottom, Top)).

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
    (Input >= 0, Input < Size -> Column = Input; read_column(Size, Column)).

read_row(Size, Row) :-
    write('\e[94m    Row: \e[0m'),
    get_int(Input),
    (Input >= 0, Input < Size -> Row = Input; read_row(Size, Row)).

read_move(Size, Move) :-
    read_row(Size, Row),
    read_column(Size, Column),
    Move = (Row-Column).

% ------------------------------------------------------ DISPLAY GAME

display_game(Board):-
    cls,
    length(Board, Size),
    display_top_indexes(Size),
    display_rows(Board, 0, Size).

display_top_indexes(Size):-
    Size1 is Size - 1,
    write('        ╭'),
    write_n_times('───┬', Size1),
    write('───╮\n'),
    write('        │'), 
    display_top_indexes(0, Size),
    write('    ╭───┼'),
    write_n_times('───┼', Size1),
    write('───┤\n').
display_top_indexes(Size, Size):- nl.
display_top_indexes(N, Size):-
    N1 is N + 1,
    write('\e[91m '), write(N), write('\e[0m │'),
    display_top_indexes(N1, Size).

display_rows([H], N, Size):-
    Size1 is Size - 1,
    N1 is N + 1,
    write('    │\e[94m '), write(N), write('\e[0m │'),
    display_row(H),
    write('    ╰───┴'), write_n_times('───┴', Size1), write('───╯\n').
display_rows([H|B], N, Size):-
    Size1 is Size - 1,
    N1 is N + 1,
    write('    │\e[94m '), write(N), write('\e[0m │'),
    display_row(H),
    write('    ├───┼'), write_n_times('───┼', Size1), write('───┤\n'),
    display_rows(B, N1, Size).
display_row([H]):-
    display_piece(H), write('│\n').
display_row([H|B]):-
    display_piece(H), write('│'),
    display_row(B).

% ------------------------------------------------------ DISPLAY PIECE

display_piece(p1) :- write('\e[93m ● \e[0m').
display_piece(p2) :- write('\e[95m ● \e[0m').
display_piece(c1) :- write('\e[93m ● \e[0m').
display_piece(c2) :- write('\e[95m ● \e[0m').
display_piece(x) :- write('   ').

% ------------------------------------------------------ WRITE N TIMES

write_n_times(_, 0).
write_n_times(String, N):-
    write(String),
    N1 is N - 1,
    write_n_times(String, N1).

% ------------------------------------------------------ CLEAR SCREEN    

cls :- write('\33\[2J').
