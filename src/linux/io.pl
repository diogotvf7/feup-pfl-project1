% ------------------------------------------------------ GET INT

/**
* Gets a user input int ranging from Bottom to Top
* get_int(-N, +Bottom, +Top)
*/
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

/**
* Reads the column from a move input by the user and checks for validity
*   read_column(+Size, -Column)
*/
read_column(Size, Column) :-
    write('\e[91m Column: \e[0m'),
    get_int(Input),
    (Input >= 0, Input < Size -> Column = Input; read_column(Size, Column)).

/**
* Reads the row from a move input by the user and checks for validity
*   read_row(+Size, -Row)
*/
read_row(Size, Row) :-
    write('\e[94m    Row: \e[0m'),
    get_int(Input),
    (Input >= 0, Input < Size -> Row = Input; read_row(Size, Row)).

/**
* Calls the other function for reading a move and constructs the actual move
*   read_move(+Size, -Move)
*/
read_move(Size, Move) :-
    read_row(Size, Row),
    read_column(Size, Column),
    Move = (Row-Column).

% ------------------------------------------------------ DISPLAY GAME

/**
* Displays the received board. Resorts to calls to other functions.
*   display_game(+Board)
*/
display_game(Board):-
    length(Board, Size),
    display_top_indexes(Size),
    display_rows(Board, 0, Size).

/**
* Displays the top indexes on the board as well as some frames allowing the player to easily read the coordinates
*   display_top_index(+Size)
*/
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

/**
* Displays all the content in each row, including indexes, frames and the player pieces 
*   display_rows(+Board, +N, +Size)
*/
display_rows([H], N, Size):-
    Size1 is Size - 1,
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

/**
* Prints the pieces according to the player that made the move
*   display_piece(+String)
*/
display_piece('Player 1') :- write('\e[93m ● \e[0m').
display_piece('Player 2') :- write('\e[95m ● \e[0m').
display_piece('Computer 1') :- write('\e[93m ● \e[0m').
display_piece('Computer 2') :- write('\e[95m ● \e[0m').

display_piece('bp1') :- write('\e[5;93m ● \e[0m').
display_piece('bp2') :- write('\e[5;95m ● \e[0m').
display_piece('bc1') :- write('\e[5;93m ● \e[0m').
display_piece('bc2') :- write('\e[5;95m ● \e[0m').

display_piece('_') :- write('\e[5;91m _ \e[0m').
display_piece(' ') :- write('   ').

% ------------------------------------------------------ WRITE N TIMES

/**
* Prints the received char n times
*   write_n_times(+String, +N)
*/
write_n_times(_, 0).
write_n_times(String, N):-
    write(String),
    N1 is N - 1,
    write_n_times(String, N1).

% ------------------------------------------------------ CLEAR SCREEN    

/**
* Prints a char responsible for clearing the terminal
*   cls
*/
cls :- write('\33\[2J'), nl.
