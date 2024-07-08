# .lem, my Lem configuration files

## Installation

```shell
$ git clone https://github.com/garlic0x1/.lem ~/.config/lem
```

## keybindings.lisp

General modifications to the global keymap.

| Binding  | Description                          |
| -------- | ------------------------------------ |
| C-[hjkl] | Switches windows with vi keys        |
| C-w *    | Misc navigation for code and windows |
| M-l *    | Open up REPLs                        |
| F11      | Toggle fullscreen                    |

## paredit++.lisp

Quality of life improvements for paredit-mode.

- Auto-formatting on newlines and backspace.
- Backspace clears preceding whitespace.
- Custom keybindings.

## locals.lisp

Directory-local dictionaries.

## completions.lisp

Modifications to completions (and also prompting right now).

- Completions automatically present themselves on a prompt,
after enter, and on backspace.
- Prompts are shown on the bottom, with completions
like the inverse of Emacs' Vertico.

## file-prompt.lisp

Make backspace cut a node off the file tree,
something I like to help move around faster.

## os.lisp

A set of commands to help me interact with my OS,
I mostly just use `M-x killall` and `M-x delete-current-file`.

## modeline.lisp

I have slimmed down the modeline, removing buffer percentage,
and hiding minor modes and lisp package by default.

It looks ugly with my screen size to have
too many things crowding the modeline.

## misc.lisp

Non-comprehensive list of things here:

- Transparency toggle for SDL2.
- Enable C-z suspend for ncurses.
- Enable Vi mode globally, and set up hooks for Paredit.
- Boot to a REPL.
- Enable auto-formatting and automatically delete trailing spaces.
- Disable scroll recentering.
- Disable auto-balancing windows.

...
and other miscellaneous commands.

## appearance.lisp

- Load FiraCode fonts if possible.
- Make text big.
- Disable multiplexer bar.


## places.lisp

Use "C-x C-d" to fuzzy-find files in recently visited areas.

## repl.lisp

Use "C-c C-h" to fuzzy-find things in REPL history.

## See Also

* [fukamachi/.lem](https://github.com/fukamachi/.lem)
* [sasanidas/lem-config](https://codeberg.org/sasanidas/lem-config)
* [lem-project/lem](https://github.com/lem-project/lem)
