% :- use_module(library(between)).
% :- use_module(library(lists)).
% :- ['src/util.pl'].
% :- ['src/io.pl'].

% -------------------------------------------------------------------------------

% ╮ ┬ ╭ ╰ ┴ ╯ ─  │ ┤ ├ ┼ ● ○ 

perpendicular(Direction, PerpendicularDirection) :-
    write('Direction: '), write(Direction), nl,
    % member(Direction, [up, down, left, right]),
    % !,
    (
        (Direction == up ; Direction == down) -> PerpendicularDirection = left-right
        ;
        (Direction == left ; Direction == right) -> PerpendicularDirection = up-down
    ).

% ------------------------------------------------------------------------------- DISPLAY GAME


:-  
    perpendicular(up, PerpendicularDirections1),
    write('PerpendicularDirections1: '), write(PerpendicularDirections1), nl,
    perpendicular(down, PerpendicularDirections2),
    write('PerpendicularDirections2: '), write(PerpendicularDirections2), nl,
    perpendicular(left, PerpendicularDirections3),
    write('PerpendicularDirections3: '), write(PerpendicularDirections3), nl,
    perpendicular(right, PerpendicularDirections4),
    write('PerpendicularDirections4: '), write(PerpendicularDirections4), nl.


    % write('\e[90m black \e[0m'), nl,
    % write('\e[91m red \e[0m'), nl,
    % write('\e[92m green \e[0m'), nl,
    % write('\e[93m yellow \e[0m'), nl,
    % write('\e[94m blue \e[0m'), nl,
    % write('\e[95m magenta \e[0m'), nl,
    % write('\e[96m cyan \e[0m'), nl,
    % write('\e[97m white \e[0m').
    
% -------------------------------------------------------------------------------
