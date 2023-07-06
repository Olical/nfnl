# nfnl

Enhance your [Neovim][neovim] experience through [Fennel][fennel] with zero
overhead. Write Fennel, run Lua, nfnl will not load unless you're actively
modifying your Neovim configuration or plugin source code.

- Only loads when working in directories containing an `.nfnl` configuration
  file.
- Automatically compiles `*.fnl` files to `*.lua` when you save your changes.
- Can be used for your Neovim configuration or plugins.
- Includes a Clojure inspired standard library (based on [Aniseed][aniseed]).

## Usage

TODO

## Configuration

TODO

## Installation

TODO

## Standard library

TODO

## Macros

TODO

## Opinions

TODO

## Tips

TODO .gitattributes, .ignore

## Development

If you have nfnl installed in Neovim you should be able to just modify Fennel
files and have them get recompiled automatically for you. So nfnl is compiled
with nfnl. This does however mean you can perform an Oopsie and break nfnl,
rendering it useless to recompile itself with fixed code.

If you run into issues like this, you can execute `script/bootstrap-dev` to run
a file watching Fennel compiler and `script/bootstrap` to compile everything
with a one off command. Both of these lean on `script/fennel.bb` which is a
smart Fennel compiler wrapper written in [Babashka][babashka]. This wrapper
relies on the bundled Fennel compiler at `script/fennel.lua`, so it will ignore
any Fennel version installed at the system level on the CLI.

So you'll need the following to use the full development suite:

- A Lua runtime of some kind to execute `script/fennel.lua`.
- [Babashka][babashka] to execute `script/fennel.bb`.
- [Entr][entr] if you want to use file watching with `script/bootstrap-dev`.

The bootstrap tools should only really ever be required during the initial
development of this plugin or if something has gone catastrophically wrong and
nfnl can no longer recompile itself. Normally having nfnl installed and editing
the `.fnl` files should be enough.

## Unlicensed

Find the full [Unlicense][unlicense] in the `UNLICENSE` file, but here's a
snippet.

> This is free and unencumbered software released into the public domain.
>
> Anyone is free to copy, modify, publish, use, compile, sell, or distribute
> this software, either in source code form or as a compiled binary, for any
> purpose, commercial or non-commercial, and by any means.

`lua/nfnl/fennel.lua` and `script/fennel.lua` are excluded from this licensing,
they're downloaded from the [Fennel][fennel] website and retains any license
used by the original author. We vendor it within this tool to simplify the user
experience.

[neovim]: https://neovim.io/
[fennel]: https://fennel-lang.org/
[aniseed]: https://github.com/Olical/aniseed
[conjure]: https://github.com/Olical/conjure
[unlicense]: http://unlicense.org/
[ripgrep]: https://github.com/BurntSushi/ripgrep
[babashka]: https://babashka.org/
[entr]: https://eradman.com/entrproject/
