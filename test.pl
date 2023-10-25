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
