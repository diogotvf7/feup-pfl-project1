% :- use_module(library(between)).

delta(Postion, Direction, NewPosition) :-
    member(Direction, [up, down, left, right]),
    (Row-Col) = Postion,
    (
        Direction == up -> NewPosition = (Row1-Col), Row1 is Row - 1;
        Direction == down -> NewPosition = (Row1-Col), Row1 is Row + 1;
        Direction == left -> NewPosition = (Row-Col1), Col1 is Col - 1;
        Direction == right -> NewPosition = (Row-Col1), Col1 is Col + 1
    ).

% -------------------------------------------------------------------------------

:-
    Position = (2-2),
    delta(Position, up, Up),
    delta(Position, down, Down),
    delta(Position, left, Left),
    delta(Position, right, Right),
    write('Up: '), write(Up), nl,
    write('Down: '), write(Down), nl,
    write('Left: '), write(Left), nl,
    write('Right: '), write(Right), nl.

% -------------------------------------------------------------------------------