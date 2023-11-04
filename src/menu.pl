% ------------------------------------------------------ OPTIONS MENU

options_menu(Header, Options):-
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
    (
        get_int(Input, 1, 3) ->
        (
            Input == 1, cls, play;
            Input == 2, cls, rules_menu;
            Input == 3, cls, exit_menu
        );
        (
            write('Invalid input.\n'), main_menu(Input)
        )
    )
    .

rules_menu:-
    fail.
exit_menu:-
    fail.
