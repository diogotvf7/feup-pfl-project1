/**
 * Packs or unpacks the game state.
 * This unpacks the GameState:
 *     game_state_pack(+GameState, -Board, -CurrentPlayer, -Opponent)
 * This packs the GameState:
 *     game_state_pack(-GameState, +Board, +CurrentPlayer, +Opponent)
 */
game_state_pack(GameState, Board, CurrentPlayer, Opponent, Difficulty):-
    GameState = [Board, CurrentPlayer, Opponent, Difficulty].

/**
* Switches the current player
*   switch_current_player(+State, -NewState)
*/
switch_current_player(State, NewState):-
    game_state_pack(State, Board, CurrentPlayer, Opponent, Difficulty),
    game_state_pack(NewState, Board, Opponent, CurrentPlayer, Difficulty).

/**
* Retrieves a new position according to the direction received
*   mx_delta(+Position, +Direction, -NewPosition)
*/
mx_delta(Postion, Direction, NewPosition):-
    !,
    (Row-Col) = Postion,
    (
        Direction == up -> NewPosition = (Row1-Col), Row1 is Row - 1;
        Direction == down -> NewPosition = (Row1-Col), Row1 is Row + 1;
        Direction == left -> NewPosition = (Row-Col1), Col1 is Col - 1;
        Direction == right -> NewPosition = (Row-Col1), Col1 is Col + 1
    ).

/**
* Returns the element (piece or empty spot) according to the position received.
*   mx_get(+Position, +Matrix, -Element)  
*/
mx_get(Position, Matrix, Element):-
    (Row-Col) = Position,
    nth0(Row, Matrix, RowList),
    nth0(Col, RowList, Element).

/**
* Check if the position is valid in the received matrix
*   mx_valid_position(+Matrix, +Position)
*/
mx_valid_position(Matrix, Position):-
    (Row-Col) = Position,
    length(Matrix, Rows),
    length(Matrix, Cols),
    Row >= 0, Row < Rows,
    Col >= 0, Col < Cols.

/**
* Returns the perpendicular directions to the received direction
*   perpendicular(+Direction, -PerpendicularDirection)
*/
perpendicular(Direction, PerpendicularDirection):-
    (
        (Direction == up ; Direction == down) -> PerpendicularDirection = left-right
        ;
        (Direction == left ; Direction == right) -> PerpendicularDirection = up-down
    ).

/**
* Returns the max value in a list
*   lmax(+[H|B], -Max)
*/
lmax([H|B], Max):-
    lmax(B, H, Max).

lmax([], Max, Max).

lmax([H|B], Curr, Max):-
    (H > Curr -> NewCurr is H; NewCurr is Curr),
    lmax(B, NewCurr, Max).

/**
* Return the bigger value between the received values
*   max(+A, +B, -B)
*/
max(A, B, B):- B >= A, !.
max(A, _, A).

/**
* Checks if X is false, returns true in case it is false, fails otherwise
*   not(+X)
*/
not(X):- X, !, fail.
not(_X).

/**
* Writes the text in the center of a given space
*   center_text(+Text, +Space)
*/
center_text(Text, Space):-
    strlen(Text, L),
    Half is (Space-L)/2,
    PaddingL is floor(Half),
    PaddingR is ceiling(Half),
    write_n_times(' ', PaddingL),
    write(Text),
    write_n_times(' ', PaddingR).

/**
* Compares the length of two arrays and return the biggest
*   array_cmp(+Array1, +Array2, -Largest)
*/
array_cmp(Array1, Array2, Largest):-
    length(Array1, Length1),
    length(Array2, Length2),
    (
        Length1 > Length2 -> Largest = Array1;
        Length2 >= Length1 -> Largest = Array2
    ).


/**
* Returns the size of a string without extra chars due to coloring
*   strlen(+[27|B], -N)
*/
strlen([], 0).
strlen([27|B], N):-
    skip(B, N).
strlen([''|B], N):-
    skip(B, N).
strlen([_|T], N):- 
    strlen(T, N1), 
    N is N1 + 1.
strlen(S, N):- 
    atom_codes(S, L),
    strlen(L, N).

/**
* Skips reading if a \ is found and only returns reading when it finds char N
*   skip(+[109|B], +N)
*/
skip([109|B], N):-
    strlen(B, N).
skip([_|B], N):-
    skip(B, N).
