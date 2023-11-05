% :- use_module(library(between)).
% :- use_module(library(lists)).
% :- ['src/util.pl'].
% :- ['src/game_logic.pl'].
% :- ['src/io.pl'].
% :- ['src/board.pl'].


% -------------------------------------------------------------------------------

%  ╭ ─ ╮ ┬  ╰ ─ ╯ ┴  │ ┤ ├ ┼ ● ○ 
%  
% ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭─╮   ╭─╮  ╭───────╮
% │ ╭───╮ │  │  ╭─╮  │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ │   │ │  ╰──╮ ╭──╯
% │ │   │ │  │  ╰─╯  │  │ │   │ │  │ │   ╰─╯  │ │   ╰─╯  │ │   │ │  │ │   │ │     │ │   
% │ │   ╰─╯  │ ╭─╮ ╭─╯  │ │   │ │  │ ╰─────╮  │ ╰─────╮  │ │   ╰─╯  │ │   │ │     │ │   
% │ │   ╭─╮  │ │ │ │    │ │   │ │  ╰─────╮ │  ╰─────╮ │  │ │   ╭─╮  │ │   │ │     │ │   
% │ │   │ │  │ │ │ │    │ │   │ │  ╭─╮   │ │  ╭─╮   │ │  │ │   │ │  │ │   │ │     │ │   
% │ ╰───╯ │  │ │ │ │    │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │     │ │   
% ╰───────╯  ╰─╯ ╰─╯    ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯     ╰─╯   
% -------------------------------------------------------------------------------



strlen([], 0).
strlen([27|B], N):-
    skip(B, N).
strlen([''|B], N):-
    skip(B, N).

skip([109|B], N):-
    strlen(B, N).
skip([_|B], N):-
    skip(B, N).

strlen([H|T], N):- 
    strlen(T, N1), 
    N is N1 + 1.

strlen(S, N) :- 
    atom_codes(S, L),
    strlen(L, N).
     
:-  
    % prompt(_, 'ASDASD'),
    % read(FirstLine).

    % trace,
    strlen('\e[90m01234567\e[0m', S1),
    write('S1: '), write(S1), nl.

    % atom_codes('\e[5masdasd', L),
    % write('L: '), write(L), nl,
    % atom_codes('\e[90m black \e[0m', L1),
    % write('L1: '), write(L1), nl.

    % number_codes(L2, '\e[5;91m red \e[0m'),
    % write('L2: '), write(L2), nl.


    % write('\e[90m black \e[0m'), nl,
    % write('\e[91m red \e[0m'), nl,
    % write('\e[92m green \e[0m'), nl,
    % write('\e[93m yellow \e[0m'), nl,
    % write('\e[94m blue \e[0m'), nl,
    % write('\e[95m magenta \e[0m'), nl,
    % write('\e[96m cyan \e[0m'), nl,
    % write('\e[97m white \e[0m').
    
% -------------------------------------------------------------------------------
