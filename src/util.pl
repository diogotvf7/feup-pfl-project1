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

mx_exclude_perimeter(Matrix, NewMatrix):-
    length(Matrix, NRows),
    length(Matrix, NCols),
    NRows1 is NRows - 1,
    NCols1 is NCols - 1,
    exclude([Row, _]>>(Row = 0), Matrix, Matrix1),
    exclude([Row, _]>>(Row = NRows1), Matrix1, Matrix2),
    exclude([_, Col]>>(Col = 0), Matrix2, Matrix3),
    exclude([_, Col]>>(Col = NCols1), Matrix3, NewMatrix).

mx_exclude_row(Matrix, NewMatrix, N):-
    mx_exclude_row(Matrix, NewMatrix, N, 0).
    
mx_exclude_row([H|B], [H|NewB], N, I):-
    I \== N,
    !,
    I1 is I + 1,
    mx_exclude_row(B, NewB, N, I1).

mx_exclude_row([H|B], NewMatrix, N, N):-
    !,
    I1 is I + 1,
    mx_exclude_row(B, NewMatrix, N, I1).

mx_exclude_column(Matrix, N, NewMatrix):-

max(A, B, B) :- B >= A, !.
max(A, B, A).

not(X):- X, !, fail.
not(_X).