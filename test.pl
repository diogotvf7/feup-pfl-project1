# :- use_module(library(system)).

test :-
    write('\e[1;31m This is red text \e[0m'), nl,
    write('\e[1;34m This is red text \e[0m'), nl,
    write('\e[5m Blinking text \e[0m'), nl,
    write('\e[2m Faint or decreased intensity \e[0m'), nl,
    write('\e[38;2;255;0;0m This is super red \e[0m'), nl,
    write('\e[38;2;0;255;0m This is super green \e[0m'), nl,
    write('\e[38;2;0;0;255m This is super blue \e[0m'), nl,
    write('\e[38;2;138;40;137m This is purple \e[0m'), nl,
    write('\e[5;91m This is blinking red text \e[0m'), nl,
    write('\e[5;94m This is blinking blue text \e[0m'), nl
    .

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
    % MOVE = (X-Y).

:-
    read_move(MOVE, 10).