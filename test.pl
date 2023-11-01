% :- use_module(library(between)).
% :- use_module(library(lists)).
% :- ['src/util.pl'].
% :- ['src/io.pl'].

test(Move):-
    Size1 is 8,
    Move = Row-Column,
    (Row == 0; Row == Size1; Column == 0; Column == Size1),
    write('Ok').


% -------------------------------------------------------------------------------

% :-
%     test(1),
%     test(2),
%     test(3),
%     test(4).

% -------------------------------------------------------------------------------
