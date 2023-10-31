valid_move(State, NewState):-
    game_state_pack(State, Board, Player, Opponent),
    length(Board, Size),
    read_move(Size, Move),
    (check_valid_move(State, Move) ->
        update_board(State, Move, NewState)
        ;
        write('Invalid move!\n'),
        valid_move(State, NewState)
    ).

check_valid_move(State, Move):-
    game_state_pack(State, Board, Player, Opponent),
    Move = (Row-Column),
    nth0(Row, Board, BoardRow),
    nth0(BoardColumn, BoardRow, Element),
    write('Element: \''), write(Element), write('\''), nl,
    Element == ' '.
    % check_flank(State, Move).

check_flank(State, Move):-
    check_segment(Move, up, State, 0),
    check_segment(Move, down, State, 0),
    check_segment(Move, left, State, 0),
    check_segment(Move, rigth, State, 0).

% Aqui queremos ler pelo menos uma peça do adversário
check_segment(Move, Direction, State, 0):-
    game_state_pack(State, Board, Player, Opponent),
    delta(Move, Direction, Move1),
    (Row1-Column1) = Move1,
    nth0(Row1, Board, BoardRow),
    nth0(Column1, BoardRow, Element),
    Element == Player -> false,
    (Element == Opponent -> 
        check_segment((Row1-Column1), State, 1),
        place_disc(Row1, Column1, Player, Board, NewBoard),
        game_state_pack(State, NewBoard, Player, Opponent)
        ;
        false
    ).

% Aqui queremos ler peças do oponente ou apenas uma peça do jogador
check_segment(Move, Direction, State, 1):-
    game_state_pack(State, Board, Player, Opponent),
    delta(Move, Direction, Move1),
    (Row1-Column1) = Move1,
    nth0(Row1, Board, BoardRow),
    nth0(Column1, BoardRow, Element),
    (Element == Opponent -> 
        check_segment((Row1-Column1), Direction, State, 1),
        place_disc(Row1, Column1, Player, Board, NewBoard),
        game_state_pack(State, NewBoard, Player, Opponent)
    );
    (Element == Player -> 
        check_segment((Row1-Column), Direction, State, 2),
        place_disc(Row1, Column1, Player, Board, NewBoard),
        game_state_pack(State, NewBoard, Player, Opponent)
        ;
        false
    ).


update_board(State, Move, NewState):-
    Move = (Row-Column),
    game_state_pack(State, Board, CurrentPlayer, Opponent),
    % (CurrentPlayer = 1 ->
    %     place_disc(Row, Column, '1', Board, NewBoard);
    %     place_disc(Row, Column, '2', Board, NewBoard)
    % ),
    place_disc(Row, Column, CurrentPlayer, Board, NewBoard),
    game_state_pack(NewState, NewBoard, Opponent, CurrentPlayer).


place_disc(0, Column, Element, [H|B], [NewH|B]):-
    place_disc(Column, Element, H, NewH),
    !.
place_disc(Row, Column, Element, [H|B], [H|NewB]):-
    Row > 0,
    Row1 is Row - 1,
    place_disc(Row1, Column, Element, B, NewB).

place_disc(0, Element, [_|B], [Element|B]) :- !.
place_disc(I, Element, [H|B], [H|NewB]) :-
    I > 0,
    I1 is I - 1,
    place_disc(I1, Element, B, NewB).

% flipping()

winning_condition(State):-
    false.