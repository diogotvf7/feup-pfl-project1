/**
 * Packs or unpacks the game state.
 * This unpacks the GameState:
 *     game_state_pack(+GameState, -Board, -CurrentPlayer, -Opponent)
 * This packs the GameState:
 *     game_state_pack(-GameState, +Board, +CurrentPlayer, +Opponent)
 */
game_state_pack(GameState, Board, CurrentPlayer, Opponent) :-
    GameState = [Board, CurrentPlayer, Opponent].

switch_current_player(State, NewState):-
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    game_state_pack(NewState, Board, Opponent, CurrentPlayer).

mx_delta(Postion, Direction, NewPosition) :-
    member(Direction, [up, down, left, right]),
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
    member(Direction, [up, down, left, right]),
    !,
    (
        Direction == up ; Direction == down -> PerpendicularDirection = horizontal;
        Direction == left ; Direction == right -> PerpendicularDirection = vertical
    ).


max(A, B, B) :- B >= A, !.
max(A, B, A).

not(X):- X, !, fail.
not(_X).