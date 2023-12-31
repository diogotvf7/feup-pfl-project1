% ------------------------------------------------------ OPTIONS MENU
/**
* Frames the given Header and Options for beauty purposes only
*   options_menu(+Header, +Options)
*/
options_menu(Header, Options):-
    cls,
    frame_header_s0(Header),
    frame_options_s0(Options),
    !.

% ------------------------------------------------------ FRAME HEADER

/**
* Contructs the frame to place the Header on
*   frame_header_s0(+Header)
*   frame_header_s1(+[H|B])
*/
frame_header_s0(Header):-
    write('╭'), write_n_times('─', 100), write('╮\n'),
    write('│'), write_n_times(' ', 100), write('│\n'),
    frame_header_s1(Header),
    write('│'), write_n_times(' ', 100), write('│\n').
frame_header_s1([H|B]):-
    write('│'),   center_text(H, 100),   write('│\n'),
    frame_header_s1(B).
frame_header_s1([]).

% ------------------------------------------------------ FRAME OPTIONS
/**
* Contructs the frame to place the Option on
*   frame_header_s0(+Option)
*   frame_header_s1(+[H|B])
*/
frame_options_s0(Option):-
    frame_options_s1(Option),
    write('╰'), write_n_times('─', 100), write('╯\n').
frame_options_s1([H|B]):-
    write('├'), write_n_times('─', 100), write('┤\n'),
    write('│'),   center_text(H, 100),   write('│\n'),
    frame_options_s1(B).
frame_options_s1([]).

% ------------------------------------------------------ WINNER MENU

/**
*  Prints the winner menu due to calling options_menu/2 and the final board, allows user to choose next step
*   winner_menu(+Board, +Winner)
*/
winner_menu(Board, Winner):-
    (
        Winner == 'Player 1' -> ColoredWinner = '\e[93mPlayer 1\e[0m';
        Winner == 'Player 2' -> ColoredWinner = '\e[95mPlayer 2\e[0m';
        Winner == 'Computer 1' -> ColoredWinner = '\e[93mComputer 1\e[0m';
        Winner == 'Computer 2' -> ColoredWinner = '\e[95mComputer 2\e[0m'
    ),
    options_menu(['Game Over!', 'And the winner is:', ColoredWinner], ['1. Go to main menu', '2. Exit']),
    display_game(Board),
    get_int(Input, 1, 2),
    (
        Input == 1 -> true;
        Input == 2 -> halt
    ),
    cls.

% ------------------------------------------------------ MAIN MENU

/**
* Prints the main menu due to calling options_menu/2 and allows user to choose next step
*   main_menu(-Input)
*/
main_menu(Input):-
    Header = ['\e[5;96m╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭─╮   ╭─╮  ╭───────╮\e[0m',
              '\e[5;96m│ ╭───╮ │  │  ╭─╮  │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ │   │ │  ╰──╮ ╭──╯\e[0m',
              '\e[5;96m│ │   │ │  │  ╰─╯  │  │ │   │ │  │ │   ╰─╯  │ │   ╰─╯  │ │   │ │  │ │   │ │     │ │   \e[0m',
              '\e[5;96m│ │   ╰─╯  │ ╭─╮ ╭─╯  │ │   │ │  │ ╰─────╮  │ ╰─────╮  │ │   ╰─╯  │ │   │ │     │ │   \e[0m',
              '\e[5;96m│ │   ╭─╮  │ │ │ │    │ │   │ │  ╰─────╮ │  ╰─────╮ │  │ │   ╭─╮  │ │   │ │     │ │   \e[0m',
              '\e[5;96m│ │   │ │  │ │ │ │    │ │   │ │  ╭─╮   │ │  ╭─╮   │ │  │ │   │ │  │ │   │ │     │ │   \e[0m',
              '\e[5;96m│ ╰───╯ │  │ │ │ │    │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │     │ │   \e[0m',
              '\e[5;96m╰───────╯  ╰─╯ ╰─╯    ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯     ╰─╯   \e[0m'],
    Options = ['1. Play',
               '2. How to play',
               '3. Exit'],
    options_menu(Header, Options),
    get_int(Input, 1, 3).

% ------------------------------------------------------ PLAY MENU

/**
* Calls all the other menus that allow to configure the game and returns the resulting config
*   play_menu(-Config)
*/
play_menu(Config):-
    get_size(Size),
    get_mode(Player1, Player2),
    (
        (Player1 \== 'Player 1'; Player2 \== 'Player 2') -> 
        get_difficulty(Difficulty); 
        Difficulty = none
    ),
    Config = [Player1, Player2, Size, Difficulty],
    cls.

% ------------------------------------------------------ GET SIZE

/**
* Allows the user to choose the size of the board
*   get_size(-Size)
*/
get_size(Size):-
    Header = ['Insert the size of the board:'],
    Options = ['The value must be between 5 and 10'],
    options_menu(Header, Options),
    get_int(Size, 5, 10).

% ------------------------------------------------------ GET MODE

/**
* Allows the user to choose the game mode
*   get_mode(-Player1, -Player2)
*/
get_mode(Player1, Player2):-
    Header = ['Insert the mode of the game:'],
    Options = ['1. Player vs Player',
               '2. Player vs Computer',
               '3. Computer vs Player',
               '4. Computer vs Computer'],
    options_menu(Header, Options),
    get_int(Mode, 1, 4),
    (
        Mode == 1 -> Player1 = 'Player 1', Player2 = 'Player 2';
        Mode == 2 -> Player1 = 'Player 1', Player2 = 'Computer 2';
        Mode == 3 -> Player1 = 'Computer 1', Player2 = 'Player 2';
        Mode == 4 -> Player1 = 'Computer 1', Player2 = 'Computer 2'
    ).

% ------------------------------------------------------ GET DIFFICULTY

/**
* Allows the user to choose the difficulty of the bot
*   get_difficulty(-Difficulty)
*/
get_difficulty(Difficulty):-
    Header = ['Insert the difficulty of the computer:'],
    Options = ['1. Easy',
               '2. Hard'],
    options_menu(Header, Options),
    get_int(Difficulty, 1, 2).

% ------------------------------------------------------ RULES MENU

/**
* Prints the game rules menu due to calling options_menu/2 and allows user to choose next step
*   rules_menu()
*/
rules_menu:-
    Header = ['   Crosscut is a two-player game played on a square board, size    ',
              '10x10 or smaller, initially empty. Double-sided discs, yellow on   ',
              'one side and magenta on the other, are used. The two players,      ', 
              'Yellow and Magenta, take turns placing their discs (discs showing  ', 
              'their color) on the board, one disc per turn, starting with Yellow.', 
              'If you have a placement available, you must make one. If you don\'t', 
              'have a placement available, your turn is skipped. The goal is to   ',
              'make a segment from one side of the board to the other (vertically ', 
              'or horizontally) excluding the borders. The segment must have      ', 
              '(Board Size - 2) pieces.                                           ', 
              '   There are a few extra rules including:                          ',
              ' ',
              '1. Pieces can be placed in all unoccupied spots except the borders.',
              '2. When you surround an opponent segment with 2 of your pieces, the',
              'pieces will flip becoming yours. This is called flipping. You are  ',
              'allowed to place a piece on the border temporarily if that allows  ',
              'you to make a flipping move.                                       ',
              '3. Flipping is only doable if it doesnt cut a bigger enemy segment ', 
              'than the one you are trying to flip.                               ',
              ' ',
              '   For visual representations and further details on the game rules',
              'please visit the following link. Development was entirely based on ',
              'the rules posted                                                   ',
              ' ',
              'http://marksteeregames.com/Crosscut_rules.pdf'
            ],
    Options = ['1. Go back'],
    options_menu(Header, Options),
    get_int(Input, 1, 1).    
    
% ------------------------------------------------------ EXIT MENU

/**
* Allows the user to decide if he really wants to quit the game
*   exit_menu(-Input)
*/
exit_menu(Input):-
    Header = ['Are you sure you want to leave ?'],
    Options = ['1.Yes',
                '2. No'],
    options_menu(Header, Options),
    get_int(Input, 1, 2),
    !.
