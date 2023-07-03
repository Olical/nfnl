# nfnl (WIP, don't use, thanks)

Enhance your [Neovim][] experience with [Fennel][]. A streamlined successor to [Aniseed][] without the Clojure like syntactic opinions provided by the Aniseed macros.

## Opinions

nfnl has strong opinions about Fennel to Lua compilation within Neovim. It makes the following strong assertions that I know some people will not like, but they're for good reasons:

 - You write your Fennel code under your dotfiles or plugin's `lua/` directory.
 - The Lua files compiled by nfnl are written beside the Fennel files in `lua/`.
 - Files that should remain as Fennel and not be compiled to Lua (for macros etc) are written to `fnl/`.
 - The Fennel compilation happens when you write any Fennel file under the `lua/` directory.
 - The exact same rules apply to plugins _and_ user configuration in dotfiles.
 - You commit your Lua and Fennel files to your configuration or plugin repo.

By compiling on write to `*.fnl` and committing your `*.lua` you only need to load this plugin while working on Fennel files and you can ship your software to any user without including Fennel's compiler. All users of your code get to load the final Lua code which is stable and predictable. You also get the added bonus of being able to revert or checkout to specific commits with the Fennel and Lua staying in perfect sync without any recompilation.

## Standard library

Aniseed shipped with a fairly sprawling standard library of useful modules and functions, this wasn't reusable due to the fact that it relied on custom Aniseed specific macros. nfnl includes all of the same modules without the custom macros (as well as some new goodies imported from [Conjure][]) so you can use them in your plugins or standalone Lua processes that aren't attached to Neovim at all.

## Installation

TODO

## Usage

TODO

## Unlicensed

Find the full [Unlicense][] in the `UNLICENSE` file, but here's a snippet.

> This is free and unencumbered software released into the public domain.
>
> Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

[Neovim]: https://neovim.io/
[Fennel]: https://fennel-lang.org/
[Aniseed]: https://github.com/Olical/aniseed
[Conjure]: https://github.com/Olical/conjure
[Unlicense]: http://unlicense.org/[unlicense]
