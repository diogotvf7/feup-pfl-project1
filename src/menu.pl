% ------------------------------------------------------ OPTIONS MENU

options_menu(Header, Options):-
    cls,
    frame_header_s0(Header),
    frame_options_s0(Options),
    !.

% ------------------------------------------------------ FRAME HEADER

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

frame_options_s0(Option):-
    frame_options_s1(Option),
    write('╰'), write_n_times('─', 100), write('╯\n').
frame_options_s1([H|B]):-
    write('├'), write_n_times('─', 100), write('┤\n'),
    write('│'),   center_text(H, 100),   write('│\n'),
    frame_options_s1(B).
frame_options_s1([]).

% ------------------------------------------------------ WINNER MENU
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

play_menu(Config):-
    get_size(Size),
    get_mode(Player1, Player2),
    (
        (Player1 \== 'Player 1'; Player2 \== 'Player 2') -> 
        get_difficulty(Difficulty); 
        Difficulty = none
    ),
    Config = [Player1, Player2, Size, Difficulty],
    write('Config: '), write(Config), nl
    .

% ------------------------------------------------------ GET SIZE

get_size(Size):-
    Header = ['Insert the size of the board:'],
    Options = ['The value must be between 5 and 10'],
    options_menu(Header, Options),
    get_int(Size, 5, 10).

% ------------------------------------------------------ GET MODE

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

get_difficulty(Difficulty):-
    Header = ['Insert the difficulty of the computer:'],
    Options = ['1. Easy',
               '2. Hard'],
    options_menu(Header, Options),
    get_int(Difficulty, 1, 2).

% ------------------------------------------------------ RULES MENU

rules_menu:-
    Header = ['Game Rules'],
    Options = ['Texto grande',
                '1. Go Back'],
    options_menu(Header, Options),
    get_int(N, 1, 1).
    
% ------------------------------------------------------ EXIT MENU

exit_menu(Input):-
    Header = ['Are you sure you want to leave ?'],
    Options = ['1.Yes',
                '2. No'],
    options_menu(Header, Options),
    get_int(Input, 1, 2),
    !.
