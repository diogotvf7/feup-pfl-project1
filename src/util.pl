/**
 * Packs or unpacks the game state.
 * This unpacks the GameState:
 *     game_state_pack(+GameState, -Board, -CurrentPlayer, -Opponent)
 * This packs the GameState:
 *     game_state_pack(-GameState, +Board, +CurrentPlayer, +Opponent)
 */
game_state_pack(GameState, Board, CurrentPlayer, Opponent) :-
    GameState = [Board, CurrentPlayer, Opponent].