# nvim-pipenv-cust-utils

This is a simple and rough Neovim plugin to add some automatic pipenv utilities
for automatic detection and usage of pipenv to run Python (pytest).

Made only for my own usage but feel free to refactor and use. The plugin
is suited for my Python development workflow. I make no guarantees that
it in anyway makes sense for you to use.

## What it does

(All very experimental and probably dependent on my neovim setup.)

* Looks for Pipfile in the parent folder of current .py file and the parent of
  parent.
  * If found -> Checks if `$PATH` contains `$VIRTUAL_ENV`
    * -> Contains: Does nothing
    * -> Doesn't contain: inserts `$VIRTUAL_ENV` as the first item in `$PATH`
      * Restarts coc-nvim. For example coc-pyright gets the right virtual
        env this way.

* Sets makeprg to *pipenv run pytest*
  * With vim-dispatch installed you can now run pytest with :Make
  * The default errorformat seems to be able to catch pytest std output line
    locations and vim-dispatch populates the quickfix.
  * (Only setting the makeprg is the functionality of this plugin.)

* Uses nvim-treesitter to do a locational pytest with the `-k` pytest argument.
  * nvim-treesitter gets the current function or class name when you are in
    a Python file.
  * The class or function name is used as the `-k` pytest argument.
  * If you are in a class method, class name is still used as the `-k` argument.

```VimL
" Locational pytest can be done with command:
Pytest
```

So basically, small utils for Python development that are more than likely
implemented in several more mature vim/neovim plugins.

## Requirements

Required (my current setup):

* NVIM v0.5.0-dev
* With Lua 5.1
* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [vim-dispatch](https://github.com/tpope/vim-dispatch)
* [coc-nvim](https://github.com/neoclide/coc.nvim)

Optional (but recommended):

* [vim-root](https://github.com/airblade/vim-rooter)

## Installation

### vim-plug

An example of how to load this plugin using vim-plug:

```VimL
Plug 'nialov/nvim-pipenv-cust-utils'
```

After running `:PlugInstall`, the files should appear in your
`~/.config/nvim/plugged` directory (or whatever path you have configured for
plugins).

## Acknowledgement

Big thanks to
[nvim-example-lua-plugin](https://github.com/jacobsimpson/nvim-example-lua-plugin)
for making lua neovim plugin development simple to start.
