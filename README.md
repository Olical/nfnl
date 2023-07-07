# nfnl

Enhance your [Neovim][neovim] experience through [Fennel][fennel] with zero
overhead. Write Fennel, run Lua, nfnl will not load unless you're actively
modifying your Neovim configuration or plugin source code.

- Only loads when working in directories containing a `.nfnl.fnl` configuration
  file.
- Automatically compiles `*.fnl` files to `*.lua` when you save your changes.
- Can be used for your Neovim configuration or plugins.
- Includes a Clojure inspired standard library (based on [Aniseed][aniseed]).
- Compiles your Fennel code and then steps out of the way leaving you with plain
  Lua that doesn't require nfnl to load in the future.

## Usage

First, you must create the configuration file at the root of your project or
configuration, this can be blank if you wish to rely on the defaults for now.

```bash
echo "{}" > .nfnl.fnl
```

The first time you open a Fennel file under this directory you'll be prompted to
trust this configuration file since it's Fennel code that's executed on your
behalf. You can put any Fennel code you want in this file, just be sure to
return a table of configuration at the end.

```fennel
(print "Hello, World! From my nfnl configuration!")

{:fennel-path "..."}
```

By default, writing to any Fennel file with Neovim under the `fnl/**/*.fnl`
pattern will automatically compile it to Lua in `lua/**/*.lua`. If there are
compilations errors they'll be displayed using `vim.notify` and the Lua will not
be updated.

nfnl will refuse to overwrite any existing Lua at the destination if nfnl was
not the one to compile it, this protects you from accidentally overwriting
existing Lua with compiled output. To bypass the warning you must delete or move
the Lua file residing at the destination yourself.

Now you may use the compiled Lua just like you would any other Lua files with
Neovim. There's nothing special about it, please refer to the abundant
documentation on the topic of Neovim configuration and plugins in Lua.

You must commit the Lua into your configuration or plugin so that it can be
loaded by native Neovim Lua systems, with absolutely no knowledge of the Fennel
it originated from.

### Compiling all files

If you for whatever reason need to compile _all_ of your files to Lua at once
then you may do so by invoking the `compile-all-files` function like so.

```lua
require('nfnl')['compile-all-files']()
```

## Configuration

nfnl is configured on a per directory basis using `.nfnl.fnl` files which also
signify that the plugin should operate on the files within this directory.
Without the file the plugin is inert, meaning even if you don't lazy load it you
won't see any performance impact at startup time.

Any configuration you don't provide (an empty file or just `{}` is absolutely
fine!) will default to these values that should work fine for most people.

```fennel
{;; Passed to fennel.compileString when your code is compiled.
 ;; See https://fennel-lang.org/api for more information.
 :compiler-options {}

 ;; String to set the compiler's fennel.path to before compilation.
 :fennel-path "./?.fnl;./?/init.fnl;./fnl/?.fnl;./fnl/?/init.fnl"

 ;; String to set the compiler's fennel.macro-path to before compilation.
 :fennel-macro-path "./?.fnl;./?/init-macros.fnl;./?/init.fnl;./fnl/?.fnl;./fnl/?/init-macros.fnl;./fnl/?/init.fnl"

 ;; A list of glob patterns (autocmd pattern syntax) of files that
 ;; should be compiled. This is used as configuration for the BufWritePost
 ;; autocmd, so it'll only apply to buffers you're interested in.
 ;; Will use backslashes on Windows.
 :source-file-patterns ["fnl/**/*.fnl"]}
```

As an example, if you want to compile `.fnl` files in the root directory of your
Neovim configuration (so no `fnl` subdirectory at all) you could use this
`.nfnl.fnl` file.

```fennel
{:source-file-patterns ["*.fnl" "**/*.fnl"]}
```

## Installation

- [Lazy][lazy]: `{ "Olical/nfnl", config = true, ft = "fennel" }`
- [Plug][plug]: `Plug 'Olical/nfnl'`
- [Packer][packer]: `use "Olical/nfnl"`

[Lazy][lazy] will invoke `require('nfnl').setup()` on your behalf thanks to
`config = true` and will lazily load the plugin when you enter a Fennel file for
the first time. Other plugin managers will require some more configuration or a
manual call to the `.setup()` function in order to create the appropriate
autocmds.

- Add the dependency to your plugin manager.
- Add lazy loading rules on the Fennel filetype if you want.
- Ensure that `require('nfnl').setup()` is called either by your plugin manager
  or your configuration.

The nfnl setup function does not currently take any configuration, it just needs
to be invoked.

## Standard library

nfnl ships with a standard library used mostly for it's internal implementation,
but it can also be used by your own Neovim configuration or plugins. This is
based on [Aniseed's][aniseed] standard library but without the module system
that prevented you from using it in standard, non-Neovim, Fennel projects.

Full API documentation powered by [fenneldoc][fenneldoc] will be coming once
some issues are resolved inside that project. Until then, the source code is
your best resource.

## Macros

Fennel allows you to write inline macros with the `(macro ...)` form but they're
restricted to only being used in that one file. If you wish to have a macro
module shared by the rest of your codebase you need to mark that file as a macro
module by placing `;; [nfnl-macro]` somewhere within the source code. The exact
amount of `;` and whitespace doesn't matter, you just need a comment with
`[nfnl-macro]` inside of it.

This marker does two things:

- Instructs the compiler not to attempt to compile this file since it would
  fail. You can't compile macro modules to Lua, they use features that can only
  be referred to at compile time and simply do not translate to Lua.
- Ensures that whenever the file is written to all other non-macro modules get
  recompiled instead. Ensuring any inter-dependencies between your Fennel and
  your macro modules stays in sync and you never end up having to find old Lua
  that was compiled with old versions of your macros.

For example, here's a simplified macro file from nfnl itself at
`fnl/nfnl/macros.fnl`.

```fennel
;; [nfnl-macro]

(fn time [...]
  `(let [start# (vim.loop.hrtime)
         result# (do ,...)
         end# (vim.loop.hrtime)]
     (print (.. "Elapsed time: " (/ (- end# start#) 1000000) " msecs"))
     result#))

{: time}
```

When writing to this file, no matching `.lua` will be generated _but_ all other
source files in the project will be re-compiled against the new version of the
macro module.

This system does not currently use static analysis to work out which files
depend on each other, instead we opt for the safe approach of recompiling
everything. This should still be fast enough for everyone's needs and avoids the
horrible subtle bugs that would come with trying to be clever with it.

## OS support

Currently only developed for and tested on Arch Linux, but this should work find
on OSX and I tried my best to support Windows without actually testing it. So
I've ensured it uses the right path separators in all the places I can find.

If you try this out and it works on OSX or Windows, please let me know so I can
add it here. If you run into issues, please report them with as much detail as
possible.

## Tips

### Ignoring compiled Lua

Create a `.ignore` file so your `.lua` files don't show up in
[Telescope][telescope] when paired with [ripgrep][ripgrep] among many other
tools that respect this file.

```
lua/**/*.lua
```

You can also add these known directories and files to things like your
[Neo-tree][neotree] configuration in order to completely hide them.

### GitHub language statistics

Create a `.gitattributes` file to teach GitHub which of your files are generated
or vendored. This ensures your "languages" section on your repository page
reflects reality.

```
lua/**/*.lua linguist-generated
lua/nfnl/fennel.lua linguist-vendored
script/fennel.lua linguist-vendored
```

### LSP

I highly recommend looking into getting a good LSP setup for
`fennel-language-server`. I use [AstroNvim][astronvim] since it bundles LSP
configurations and Mason, a way to install dependencies, in one pre-configured
system. My configuration is
[here in my dotfiles](https://github.com/Olical/dotfiles/blob/b72363f77586ad08ba1581c33ee476b1f02e999f/stowed/.config/nvim/lua/user/plugins/mason.fnl).

With the Fennel LSP running I get a little autocompletion alongside really
useful unused or undeclared symbol linting. It'll also pick up things like
unbalanced parenthesis _before_ I try to compile the file.

The same can be done for Lua so you can also check the linting and static
analysis of the compiled output in order to help debug some runtime issues.

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
[plug]: https://github.com/junegunn/vim-plug
[packer]: https://github.com/wbthomason/packer.nvim
[lazy]: https://github.com/folke/lazy.nvim
[fenneldoc]: https://github.com/andreyorst/fenneldoc
[telescope]: https://github.com/nvim-telescope/telescope.nvim
[neotree]: https://github.com/nvim-neo-tree/neo-tree.nvim
[astronvim]: https://astronvim.com/
