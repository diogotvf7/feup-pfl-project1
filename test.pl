% :- use_module(library(between)).
% :- use_module(library(lists)).
% :- ['src/util.pl'].
% :- ['src/io.pl'].

% -------------------------------------------------------------------------------

% ╮ ┬ ╭ ╰ ┴ ╯ ─  │ ┤ ├ ┼ ● ○ 

% ------------------------------------------------------------------------------- FRAME TEXT

% ╭─────────────────────────────────────────────────────────────────────────────╮
% │                                                                             │
% │                                CENTERED TEXT                                │
% │                                                                             │
% ├─────────────────────────────────────────────────────────────────────────────┤
% │                                  -OPTION 1                                  │
% ├─────────────────────────────────────────────────────────────────────────────┤
% │                                  -OPTION 2                                  │
% ├─────────────────────────────────────────────────────────────────────────────┤
% │                                  -OPTION 3                                  │
% ╰─────────────────────────────────────────────────────────────────────────────╯

% center_text(Text, Space):-
%     length(Text, Length),
%     Start is 77 - Length / 2,


% frame_text(Header, Options) :-
%     frame_header(Header),
%     frame_options(Options).

frame_header_s0(Header):-
    write('╭'), write_n_times('─', 77), write('╮\n'),
    write('│'), write_n_times(' ', 77), write('│\n'),
    frame_header_s1(Header),
    write('│'), write_n_times(' ', 77), write('│\n').
frame_header_s1([H|B]):-
    length(H, Length),
    write('│'),   center_text(H, 77),   write('│'), nl,
    frame_header_s1(B).
frame_header_s1([B]):-
    length(B, Length),
    write('│'),   center_text(B, 77),   write('│'), nl.


    % write('│'), write_n_times(' ', 77), write('│'), nl. ISTO VAI PARA O FRAME OPTIONS
    % write('├'), write_n_times('─', 77), write('┤'), nl. ISTO VAI PARA O FRAME OPTIONS





% ------------------------------------------------------------------------------- DISPLAY GAME


:-  
    % AQUI
    frame_header(['ola', 'tudo bem??', 'isto esta centrado espero eu', 'coisa fixe']).


    % write('\e[90m black \e[0m'), nl,
    % write('\e[91m red \e[0m'), nl,
    % write('\e[92m green \e[0m'), nl,
    % write('\e[93m yellow \e[0m'), nl,
    % write('\e[94m blue \e[0m'), nl,
    % write('\e[95m magenta \e[0m'), nl,
    % write('\e[96m cyan \e[0m'), nl,
    % write('\e[97m white \e[0m').
    
% -------------------------------------------------------------------------------
