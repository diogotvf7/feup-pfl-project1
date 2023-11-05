% ------------------------------------------------------ OPTIONS MENU

options_menu(Header, Options):-
    cls,
    frame_header_s0(Header),
    frame_options_s0(Options).

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

% ------------------------------------------------------ MAIN MENU

main_menu(Input):-
    Header = ['╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭───────╮  ╭─╮   ╭─╮  ╭───────╮',
              '│ ╭───╮ │  │  ╭─╮  │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ ╭───╮ │  │ │   │ │  ╰──╮ ╭──╯',
              '│ │   │ │  │  ╰─╯  │  │ │   │ │  │ │   ╰─╯  │ │   ╰─╯  │ │   │ │  │ │   │ │     │ │   ',
              '│ │   ╰─╯  │ ╭─╮ ╭─╯  │ │   │ │  │ ╰─────╮  │ ╰─────╮  │ │   ╰─╯  │ │   │ │     │ │   ',
              '│ │   ╭─╮  │ │ │ │    │ │   │ │  ╰─────╮ │  ╰─────╮ │  │ │   ╭─╮  │ │   │ │     │ │   ',
              '│ │   │ │  │ │ │ │    │ │   │ │  ╭─╮   │ │  ╭─╮   │ │  │ │   │ │  │ │   │ │     │ │   ',
              '│ ╰───╯ │  │ │ │ │    │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │  │ ╰───╯ │     │ │   ',
              '╰───────╯  ╰─╯ ╰─╯    ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯  ╰───────╯     ╰─╯   '],
    Options = ['1. Play',
               '2. How to play',
               '3. Exit'],
    options_menu(Header, Options),
    get_int(Input, 1, 3).

play_menu(Config):-
    get_size(Size),
    get_mode(Player1, Player2),
    (
        (Player1 \== 'p1'; Player2 \== 'p2') -> get_difficulty(Difficulty) ; Difficulty = none
    ),
    Config = [Player1, Player2, Size, Difficulty].

get_size(Size):-
    Header = ['Insert the size of the board:'],
    Options = ['The value must be between 5 and 10'],
    options_menu(Header, Options),
    get_int(Size, 5, 10).

get_mode(Player1, Player2):-
    Header = ['Insert the mode of the game:'],
    Options = ['1. Player vs Player',
               '2. Player vs Computer',
               '3. Computer vs Player',
               '4. Computer vs Computer'],
    options_menu(Header, Options),
    get_int(Mode, 1, 4),
    (
        Mode == 1 -> Player1 = 'p1', Player2 = 'p2';
        Mode == 2 -> Player1 = 'p1', Player2 = 'c2';
        Mode == 3 -> Player1 = 'c1', Player2 = 'p2';
        Mode == 4 -> Player1 = 'c1', Player2 = 'c2'
    ).

get_difficulty(Difficulty):-
    Header = ['Insert the difficulty of the computer:'],
    Options = ['1. Easy',
               '2. Hard'],
    options_menu(Header, Options),
    get_int(Difficulty, 1, 2),
    (
        Difficulty == 1 -> Difficulty = easy;
        Difficulty == 2 -> Difficulty = hard
    ).

rules_menu:-
    Header = ['Game Rules'],
    Options = ['Texto grande',
                '1. Go Back'],
    options_menu(Header, Options),
    get_int(N, 1, 1).
    
exit_menu(Input):-
    Header = ['Are you sure you want to leave ?'],
    Options = ['1.Yes',
                '2. No'],
    options_menu(Header, Options),
    get_int(Input, 1, 2),
    !.
