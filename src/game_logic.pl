valid_move(State, NewState):-
    length(State, Size),
    read_move(Move, Size),                                        % <- Implementar
    check_valid_move(State, Move),                          % <- Verificar as regras do jogo / Implementar
    update_board(State, Move, NewState).                    % <- Colocar a peça

 
    %1- qualquer move é legal dentro do board excetuando o perimetro;
    %2- jogadas no perimetro, ou seja lugares com [x,0] ou [0,x] só podem ser usados se permitirem flipping e 
    %devem ser retirados depois. As edges devem estar sempre limpas;



place(BOARD, X, Y, ELEMENT, NEW_BOARD) :-
    nth0(Y, BOARD, ROW),
    place(X, ELEMENT, ROW, NEW_ROW),
    place(Y, NEW_ROW, BOARD, NEW_BOARD).

place(1, ELEMENT, [_|T], [ELEMENT|T]) :- !.
place(I, ELEMENT, [H|T], [H|NEW_T]) :-
    I > 1,
    I1 is I - 1,
    place(I1, ELEMENT, T, NEW_T).