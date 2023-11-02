% :- use_module(library(between)).
:- use_module(library(lists)).
% :- ['src/util.pl'].
% :- ['src/io.pl'].

% -------------------------------------------------------------------------------
mx_get(Position, Matrix, Element) :-
    (Row-Col) = Position,
    nth0(Row, Matrix, RowList),
    nth0(Col, RowList, Element).
% -------------------------------------------------------------------------------

% check_full_row([H|B], CurrentPlayer):-
%     N1 is N - 1,
%     check_full_row(CurrentPlayer, Board, N1) ; check_full_row(CurrentPlayer, Board, N1).
%     % (
%     %     for(RowIndex, 1, N1),
%     %     nth0(RowIndex, Board, Row)
%     %     check_full_row(CurrentPlayer, Row, 0)
%     % ).


/**
 * check_rows(+CurrentPlayer, +Board)
 */
check_rows(CurrentPlayer, [H]):-
    check_full_row(CurrentPlayer, H, 0).
check_rows(CurrentPlayer, [H|B]):-
    check_full_row(CurrentPlayer, H, 0); check_rows(CurrentPlayer, B).
/**
 * check_full_row(+CurrentPlayer, +Row, +State)
 */
check_full_row(CurrentPlayer, [_|B], 0):-
    check_full_row(CurrentPlayer, B, 1).
check_full_row(CurrentPlayer, [H|B], 1):-
    H == CurrentPlayer,
    check_full_row(CurrentPlayer, B, 1).
check_full_row(_, [_], 1):- !.



/**
 * check_columns(+CurrentPlayer, +Board)
 */
check_columns(CurrentPlayer, Board):-
    length(Board, N),
    N1 is N - 2,
    check_columns(CurrentPlayer, Board, N1).
    
check_columns(CurrentPlayer, Board, 1):-
    check_full_column(CurrentPlayer, Board, 1).

check_columns(CurrentPlayer, Board, N):-
    N > 1,
    (N1 is N - 1, check_columns(CurrentPlayer, Board, N1)) ; check_full_column(CurrentPlayer, Board, N).

/**
 * check_full_column(+CurrentPlayer, +Board, +Col)
 */
check_full_column(CurrentPlayer, Board, Col):-
    length(Board, N),
    N1 is N - 1,
    check_full_column(CurrentPlayer, Board, 1, Col, N1).

check_full_column(_, _, N, _, N).

check_full_column(CurrentPlayer, Board, Row, Col, N):-
    mx_get(Row-Col, Board, CurrentPlayer),
    NewRow is Row + 1,
    check_full_column(CurrentPlayer, Board, NewRow, Col, N).


% -------------------------------------------------------------------------------

% :-
    % Matrix = [[' ', ' ', ' ', ' ', ' ', ' '],
    %           [' ', ' ', '1', ' ', '1', ' '],
    %           [' ', '1', '1', '1', '1', ' '],
    %           [' ', ' ', ' ', ' ', ' ', ' '],
    %           [' ', '1', '2', '1', '1', ' '],
    %           ['2', '1', '2', '1', '1', '2']].
    % Matrix = [[' ', ' ', ' ', ' ', ' ', ' '],[' ', ' ', '1', ' ', '1', ' '],[' ', '1', '1', '1', '1', ' '],[' ', ' ', ' ', ' ', ' ', ' '],[' ', '1', '2', '1', '1', ' '],['2', '1', '2', '1', '1', '2']].
    % trace,
    % check_rows('1', [[' ', ' ', ' ', ' ', ' ', ' '],[' ', ' ', '1', ' ', '1', ' '],[' ', '1', '1', '1', '1', ' '],[' ', ' ', ' ', ' ', ' ', ' '],[' ', '1', '2', '1', '1', ' '],['2', '1', '2', '1', '1', '2']]).
    % check_rows('1', [[' ', ' ', ' ', ' ', ' ', ' '],[' ', ' ', '1', ' ', '1', ' '],[' ', '1', ' ', '1', '1', ' '],[' ', ' ', ' ', ' ', ' ', ' '],[' ', '1', '2', '1', '1', ' '],['2', '1', '2', '1', '1', '2']]).
    % check_columns('1', [[' ', ' ', ' ', ' ', ' ', ' '],[' ', ' ', '1', ' ', '1', ' '],[' ', '1', ' ', '1', '1', ' '],[' ', ' ', ' ', ' ', '1', ' '],[' ', '1', '2', '1', '1', ' '],['2', '1', '2', '1', ' ', '2']]).
    % trace, check_columns('1', [[' ', ' ', ' ', ' '],[' ', ' ', ' ', ' '],[' ', '1', ' ', ' '],[' ', ' ', ' ', ' ']]).
    % trace, check_columns('1', [[' ', ' ', ' ', ' '],[' ', '1', ' ', ' '],[' ', '1', ' ', ' '],[' ', ' ', ' ', ' ']]).
    
% -------------------------------------------------------------------------------
