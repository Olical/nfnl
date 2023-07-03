# nfnl (WIP, don't use, thanks)

Enhance your [Neovim][] experience with [Fennel][]. A streamlined successor to [Aniseed][] without the Clojure like syntax provided by the Aniseed macros.

You might also want to consider [Hotpot][], a fully featured and highly configurable plugin that does a similar thing. I intend on keeping nfnl minimal and just enough for my personal use, so Hotpot may be better for you if any of my strong opinions don't align with yours. If however you like my single minded design philosophy and don't mind the lack of options, read on!

## Opinions

nfnl has strong opinions about Fennel to Lua compilation within Neovim. It makes the following strong assertions that I know some people will not like, but they're for good reasons:

 - You write your Fennel code under your dotfiles or plugin's `lua/` directory.
 - The Lua files compiled by nfnl are written beside the Fennel files in `lua/`.
 - Files that should remain as Fennel and not be compiled to Lua (for macros etc) are written to `fnl/`.
 - The Fennel compilation happens when you write any Fennel file under the `lua/` directory.
 - The exact same rules apply to plugins _and_ user configuration in dotfiles.
 - You commit your Lua and Fennel files to your configuration or plugin repo.

By compiling on write to `*.fnl` and committing your `*.lua` you only need to load this plugin while working on Fennel files and you can ship your software to any user without including Fennel's compiler. All users of your code get to load the final Lua code which is stable and predictable. You also get the added bonus of being able to revert or checkout to specific commits with the Fennel and Lua staying in perfect sync without any recompilation.

You can add `*.lua` to your `.ignore` file to exclude it from things like [ripgrep][] which works nicely with various Neovim tools.

## Standard library

Aniseed shipped with a fairly sprawling standard library of useful modules and functions, this wasn't reusable due to the fact that it relied on custom Aniseed specific macros. nfnl includes all of the same modules without the custom macros (as well as some new goodies imported from [Conjure][]) so you can use them in your plugins or standalone Lua processes that aren't attached to Neovim at all.

## Installation

TODO

## Usage

TODO

## Development

If you have nfnl installed in Neovim you should be able to just modify Fennel files and have them get recompiled automatically for you. If you run into issues though you can execute `script/bootstrap-dev` to run a file watching Fennel compiler and `script/bootstrap` to compile everything with a one off command. Both of these lean on `script/fennel.bb` which is a smart Fennel compiler wrapper written in [Babashka][].

So you'll need the following to use the full development suite:

 - A Lua runtime of some kind.
 - [Babashka][].
 - [Entr][] if you want to use file watching.

The development bootstrap tools use the vendored copy of Fennel at `lua/nfnl/fennel.lua`, so you don't need to bring your own. The bootstrap tools should only really ever be required during the initial development of this plugin or if something has gone catastrophically wrong. Normally having nfnl installed and editing the .fnl files should be enough.

## Unlicensed

Find the full [Unlicense][] in the `UNLICENSE` file, but here's a snippet.

> This is free and unencumbered software released into the public domain.
>
> Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

`lua/nfnl/fennel` is excluded from this licensing, it's downloaded from the [Fennel][] website and retains any license used by the original author. We vendor it within this tool to simplify the user experience.

[Neovim]: https://neovim.io/
[Fennel]: https://fennel-lang.org/
[Aniseed]: https://github.com/Olical/aniseed
[Conjure]: https://github.com/Olical/conjure
[Unlicense]: http://unlicense.org/
[ripgrep]: https://github.com/BurntSushi/ripgrep
[Babashka]: https://babashka.org/
[Entr]: https://eradman.com/entrproject/
[Hotpot]: https://github.com/rktjmp/hotpot.nvim
