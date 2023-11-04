:- use_module(library(lists)).
:- use_module(library(between)).
:- ['src/game.pl'].
:- ['src/board.pl'].
:- ['src/io.pl'].
:- ['src/game_logic.pl'].
:- ['src/util.pl'].
:- ['src/menu.pl'].
 
run:-
    main_menu(Input).
    % play.

:- 
    cls,
    main_menu(Input).
    % run.