# .lem, my Lem configuration files

## Installation

```shell
$ git clone https://github.com/garlic0x1/.lem ~/.config/lem
```

## Details

Loads contrib/ollama package to talk to LLM servers.

### keybindings.lisp

Keybindings I like.

* F11      toggles fullscreen
* C-w ...  has buffer navigation commands
* C-[hjkl] switches windows vi-style
* M-l ...  starts repls
* C-[,.]   paredit slurp/spit

### paredit.lisp

Improvements to paredit-mode, with vi-mode in mind.  Some of this is to emulate what I like about emacs' lispyville.

### modes.lisp

Set up vi-mode globally, and paredit-mode in lisp buffers or repls

### file-prompt.lisp

This file modifies the behavior of the find-file prompt (C-x C-f).

C-Backspace goes back a whole path node.

### misc.lisp

Set some internal values and replaces some emojis to patch an issue with dependencies on Arch and OpenBSD. (you might not need these)

Turns on auto-formatting and deleting trailing spaces on save.

Allow C-z to suspend in ncurses.

M-x open-config
M-x kill-buffer-and-window

## Troubleshooting

If you get issues with SDL2 throwing a null pointer issue then you must debug the way SDL2_ttf is built.

On Arch, install this package to fix the issue: [garlic0x1/sdl2_ttf](https://github.com/garlic0x1/sdl2_ttf).

(This patch is in the main repositories now, so it should no longer be an issue.)

## See Also

* [fukamachi/.lem](https://github.com/fukamachi/.lem)
* [sasanidas/lem-config](https://codeberg.org/sasanidas/lem-config)
* [lem-project/lem](https://github.com/lem-project/lem)
