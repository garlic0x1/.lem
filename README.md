# .lem, my Lem configuration files

## Installation

```shell
$ git clone https://github.com/garlic0x1/.lem ~/.config/lem
```

## Details

Loads contrib/ollama package to talk to LLM servers.

### keybindings.lisp

Keybindings I like. 

* C-w ...  has buffer navigation commands
* C-a ...  has help commands
* C-[hjkl] switches windows vi-style
* M-l ...  starts repls
* C-[,.]   paredit slurp/spit

### modes.lisp

Set up vi-mode globally, and paredit-mode in lisp buffers or repls

### file-prompt.lisp

This file modifies the behavior of the find-file prompt (C-x C-f).

C-Backspace goes back a whole path node.

Path normalization when you press tab:

* ~/ -> ~/
* // -> /
...

Modify these to match your system or add handy shortcuts.

### misc.lisp

Set some internal values and replaces some emojis to patch an issue with dependencies on Arch and OpenBSD. (you might not need these)

Allow C-z to suspend in ncurses.

M-x open-config
M-x kill-buffer-and-window

## See Also

* [fukamachi/.lem](https://github.com/fukamachi/.lem)
* [sasanidas/lem-config](https://codeberg.org/sasanidas/lem-config)
* [lem-project/lem](https://github.com/lem-project/lem)
