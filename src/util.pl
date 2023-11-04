/**
 * Packs or unpacks the game state.
 * This unpacks the GameState:
 *     game_state_pack(+GameState, -Board, -CurrentPlayer, -Opponent)
 * This packs the GameState:
 *     game_state_pack(-GameState, +Board, +CurrentPlayer, +Opponent)
 */
game_state_pack(GameState, Board, CurrentPlayer, Opponent, Difficulty) :-
    GameState = [Board, CurrentPlayer, Opponent, Difficulty].

switch_current_player(State, NewState):-
    game_state_pack(State, Board, CurrentPlayer, Opponent, Difficulty),
    game_state_pack(NewState, Board, Opponent, CurrentPlayer, Difficulty).

mx_delta(Postion, Direction, NewPosition) :-
    !,
    (Row-Col) = Postion,
    (
        Direction == up -> NewPosition = (Row1-Col), Row1 is Row - 1;
        Direction == down -> NewPosition = (Row1-Col), Row1 is Row + 1;
        Direction == left -> NewPosition = (Row-Col1), Col1 is Col - 1;
        Direction == right -> NewPosition = (Row-Col1), Col1 is Col + 1
    ).

mx_get(Position, Matrix, Element) :-
    (Row-Col) = Position,
    nth0(Row, Matrix, RowList),
    nth0(Col, RowList, Element).

perpendicular(Direction, PerpendicularDirection) :-
    (
        (Direction == up ; Direction == down) -> PerpendicularDirection = left-right
        ;
        (Direction == left ; Direction == right) -> PerpendicularDirection = up-down
    ).


max(A, B, B) :- B >= A, !.
max(A, B, A).

not(X):- X, !, fail.
not(_X).

strlen(String, Length):-
    atom_chars(String, Chars),
    length(Chars, Length).

center_text(Text, Space):-
    strlen(Text, L),
    Half is (Space-L)/2,
    PaddingL is floor(Half),
    PaddingR is ceiling(Half),
    write_n_times(' ', PaddingL),
    write(Text),
    write_n_times(' ', PaddingR).

array_cmp(Array1, Array2, Largest):-
    length(Array1, Length1),
    length(Array2, Length2),
    (
        Length1 > Length2 -> Largest = Array1;
        Length2 >= Length1 -> Largest = Array2
    ).