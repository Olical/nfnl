# nfnl

Enhance your [Neovim][neovim] experience through [Fennel][fennel] with zero
overhead. Write Fennel, run Lua, nfnl will not load unless you're actively
modifying your Neovim configuration or plugin source code
([nfnl-plugin-example][nfnl-plugin-example]).

- Only loads when working in directories containing a `.nfnl.fnl` configuration
  file.
- Automatically compiles `*.fnl` files to `*.lua` when you save your changes.
- Can be used for your Neovim configuration or [plugins][nfnl-plugin-example]
  with no special configuration, it just works for both.
- Includes a Clojure inspired [standard library][apidoc] (based on
  [Aniseed][aniseed]).
- Compiles your Fennel code and then steps out of the way leaving you with plain
  Lua that doesn't require nfnl to load in the future.
- Displays compilation errors as you save your Fennel code to keep the feedback
  loop as tight as possible.

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

By default, writing to any Fennel file with Neovim under the directory
containing `.nfnl.fnl` will automatically compile it to Lua. If there are
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

## Configuration

nfnl is configured on a per directory basis using `.nfnl.fnl` files which also
signify that the plugin should operate on the files within this directory.
Without the file the plugin is inert, meaning even if you don't lazy load it you
won't see any performance impact at startup time.

Any configuration you don't provide (an empty file or just `{}` is absolutely
fine!) will default to these values that should work fine for most people.

```fennel
{;; Enables verbose notifications from nfnl, including notifications about
 ;; when it starts up and when it compiles successfully. Useful for debugging
 ;; the plugin itself and checking that it's running when you expect it to.
 :verbose false

 ;; Passed to fennel.compileString when your code is compiled.
 ;; See https://fennel-lang.org/api for more information.
 :compiler-options {;; Disables ansi escape sequences in compiler output.
                    :error-pinpoint false}

 ;; Warning! In reality these paths are absolute and set to the root directory
 ;; of your project (where your .nfnl.fnl file is). This means even if you
 ;; open a .fnl file from outside your project's cwd the compiler will still
 ;; find your macro files. If you use relative paths like I'm demonstrating here
 ;; then macros will only work if your cwd is in the project you're working on.

 ;; They also use OS specific path separators, what you see below is just an example really.
 ;; I'm not including nfnl's directory from your runtimepath, but it would be there by default.
 ;; See :rtp-patterns below for more information on including other plugins in your path.

 ;; String to set the compiler's fennel.path to before compilation.
 :fennel-path "./?.fnl;./?/init.fnl;./fnl/?.fnl;./fnl/?/init.fnl"

 ;; String to set the compiler's fennel.macro-path to before compilation.
 :fennel-macro-path "./?.fnl;./?/init-macros.fnl;./?/init.fnl;./fnl/?.fnl;./fnl/?/init-macros.fnl;./fnl/?/init.fnl"

 ;; A list of glob patterns (autocmd pattern syntax) of files that
 ;; should be compiled. This is used as configuration for the BufWritePost
 ;; autocmd, so it'll only apply to buffers you're interested in.
 ;; Will use backslashes on Windows.
 ;; Defaults to compiling all .fnl files, you may want to limit it to your fnl/ directory.
 :source-file-patterns [".*.fnl" "*.fnl" "**/*.fnl"]

 ;; A function that is given the absolute path of a Fennel file and should return
 ;; the equivalent Lua path, by default this will translate `fnl/foo/bar.fnl` to `lua/foo/bar.lua`.
 ;; See the "Writing Lua elsewhere" tip below for an example function that writes to a sub directory.
 :fnl-path->lua-path (fn [fnl-path] ...)}
```

As an example, if you only want to compile `.fnl` files under the `fnl/`
directory of your Neovim configuration (so nothing in the root directory) you
could use this `.nfnl.fnl` file instead.

```fennel
{:source-file-patterns ["fnl/**/*.fnl"]}
```

And since this is a Fennel file that's executed within Neovim you can actually
load nfnl's modules to access things like the default config values.

```fennel
(local core (require :nfnl.core))
(local config (require :nfnl.config))
(local default (config.default))

{:source-file-patterns (core.concat default.source-file-patterns ["custom-dir/*.fnl"])}
```

`config.default` accepts a table of arguments ([docs][config-default-doc]) to
change how it builds the default configuration. You can call
`(config.default {...})` on the last line of your `.nfnl.fnl` file in order to
return a modified default configuration table. You also then have the option to
call `config.default`, modify that table with extra values and then return that.

By providing a different `rtp-patterns` value (defaults to `["/nfnl$"]`) we can
include other plugins you have installed in your search paths when requiring Lua
modules or macros.

```fennel
;; Configuration that includes nfnl _and_ your-cool-plugin in the search paths.
(local config (require :nfnl.config))
(config.default {:rtp-patterns ["/nfnl$" "/your-cool-plugin$"]})

;; Configuration that includes ALL of your installed plugins in your search paths.
;; This might slow down compilation on some machines, so it's not the default.
(local config (require :nfnl.config))
(config.default {:rtp-patterns [".*"]})

;; Searching all of your plugins _and_ merging in some other custom configuration.
(local core (require :nfnl.core))
(local config (require :nfnl.config))
(core.merge
  (config.default {:rtp-patterns [".*"]})
  {:source-file-patterns ["fnl/**/*.fnl"]})
```

## Installation

- [Lazy][lazy]: `{ "Olical/nfnl", ft = "fennel" }`
- [Plug][plug]: `Plug 'Olical/nfnl'`
- [Packer][packer]: `use "Olical/nfnl"`

[Lazy][lazy] will lazily load the plugin when you enter a Fennel file for the
first time. There is no need to call `require("nfnl").setup()` right now, it's
currently a noop but it may be used eventually. Some plugin managers support
this function and will call it automatically.

- Requires Neovim > v0.9.0.
- Add the dependency to your plugin manager.
- Add lazy loading rules on the Fennel filetype if you want.

## Standard library

nfnl ships with a standard library used mostly for it's internal implementation,
but it can also be used by your own Neovim configuration or plugins. This is
based on [Aniseed's][aniseed] standard library but without the module system
that prevented you from using it in standard, non-Neovim, Fennel projects.

Full API documentation powered by [fenneldoc][fenneldoc] can be found in the
[api][apidoc] directory.

The documentation is regenerated by executing
`./script/render-api-documentation`. One limitation of using this tool is that
all top level values in a module should really be functions, if we do work
inside `(local)` for example we'll end up incurring side effects at
documentation rendering time that we may not want.

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

;; .nfnl.fnl config so you don't need to prefix globals like _G.vim.*
;; {:compiler-options {:compilerEnv _G}}

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

## Why can't I refer to the vim global in my macros?

By default, the Fennel compiler employs a compiler sandbox in your macro
modules. This means you can't refer to any free global variables such a `vim`.
You have to configure the [Fennel compiler API][api-module-doc] with the
`{:compiler-options {...}}` section of your `.nfnl.fnl` file.

You can either prefix each of these globals with `_G` like `_G.vim.g.some_var`
or you can turn off the relevant sandboxing rules. One approach is to set the
compiler environment to `_G` instead of Fennel's sanitised environment. You can
do that with the following `.nfnl.fnl` file.

```fennel
{:compiler-options {:compilerEnv _G}}
```

## OS support

Currently only developed for and tested on Arch Linux, but this works fine on
MacOS. You can see another example of creating a plugin and done on MacOS at
[this blog post](https://russtoku.github.io/posts/nfnl-experience.html). I tried
my best to support Windows without actually testing it. So I've ensured it uses
the right path separators in all the places I can find.

If you try this out and it works on MacOS or Windows, please let me know so I
can add it here. If you run into issues, please report them with as much detail
as possible.

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

### Directory local Neovim configuration in Fennel

I wrote [nvim-local-fennel][nvim-local-fennel] to solve this problem years ago
but I now recommend combining nfnl with the built in `exrc` option. Simply
`:set exrc` (see `:help exrc` for more information), create a `.nfnl.fnl` file
and then edit `.nvim.fnl`.

This will write Lua to `.nvim.lua` which will be executed whenever your Neovim
enters this directory tree. Even if you uninstall nfnl the `.lua` file will
continue to work. Colleagues who also use Neovim but don't have nfnl installed
can also use the `.nvim.lua` file provided they have `exrc` enabled (even if
they can't edit the Fennel to compile new versions of the Lua).

This solution achieves the same goal as nvim-local-fennel with far less code
_and_ built in options all Neovim users can lean on.

### Embedding nfnl inside your plugin

If you want to ship a plugin ([nfnl-plugin-example][nfnl-plugin-example]) that
depends on nfnl modules you'll need to embed it inside your project. You can
either `cp -r lua/nfnl` into `your-project/lua/nfnl` if you don't mind your
plugin's copy of nfnl colliding with other plugins or you can use
`script/embed-library` to copy the files into a lower level directory and modify
them to isolate them for your plugin specifically.

```bash
cp -r nfnl/lua/nfnl my-plugin/lua/nfnl
```

Now your plugin can always use `(require :nfnl.core)` and know it'll be around,
but you might run into issues where another plugin author has done the same and
is using an older version of nfnl that lacks some feature you require. Lua has a
global module namespace, so collisions are quite easy to accidentally cause. You
may use my embedding script (or your own) to avoid this though:

```bash
# There are more paths and options available, see the script source for more information.
# This will write to $PROJECT/lua/$PROJECT/nfnl.
SRC_DIR=nfnl/lua/nfnl PROJECT=my-plugin ./nfnl/script/embed-library
```

This will copy nfnl's Lua code into your project's directory under a namespaced
directory unique to your project. It will then perform a find and replace on the
Lua code to scope the nfnl source to your plugin, avoiding conflicts with any
other copy of nfnl.

This script depends upon [fd][fd] and [sd][sd], so make sure you install those
first! Alternatively you could modify or write your own script that works for
your OS with your available tools.

### Writing Lua elsewhere

If you're not happy with the defaults of Lua being written beside your Fennel
and still disagree with [my justifications for it][lua-in-git-justifications]
then you may want to override the `:fnl-path->lua-path` function to perform in a
way you like. Since you get to define a function, how this behaves is entirely
up to you. Here's how you could write to a sub-directory rather than just `lua`,
just include this in your `.nfnl.fnl` configuration file for your project.

```fennel
(local config (require :nfnl.config))
(local default (config.default))

{:fnl-path->lua-path (fn [fnl-path]
                       (let [rel-fnl-path (vim.fn.fnamemodify fnl-path ":.")]
                         (default.fnl-path->lua-path (.. "some-other-dir/" rel-fnl-path))))}
```

### Commands

User commands are defined inside your Fennel buffers when nfnl configuration is
detected, they are just thin wrappers around the function found in `nfnl.api`
which you can read about under the next header.

- `:NfnlFile [path]`

  - `path` defaults to `%`

  Run the matching Lua file for this Fennel file from disk. Does not recompile
  the Lua, you must use nfnl to compile your Fennel to Lua first. Calls
  nfnl.api/dofile under the hood.

- `:NfnlCompileFile [file]`

  - `file` defaults to the current file

  Executes (nfnl.api/compile-file) which will compile the specified file and write it to the appropriate `.lua` path.

- `:NfnlCompileAllFiles [path]`

  - `path` defaults to `.`

  Executes (nfnl.api/compile-all-files) which will, you guessed it, compile all
  of your files.

### Options

nfnl's user experience can be configured by `g:nfnl#...` prefixed global variables which can also be set by `.setup()` like so:

```lua
require("nfnl").setup({ compile_on_write = false })
```

These options customise general behaviour of the plugin that aren't limited to a specific directory or project.

- `g:nfnl#compile_on_write`
  Set to `false` to disable the automatic compilation on buffer write. You will then need to use the `:NfnlCompile*` commands to compile your Fennel into Lua.

### API

Although you can require any internal nfnl Lua module and call it's functions
([full index of internal modules and functions][apidoc]) there is a specific
module, `nfnl.api` ([documentation][api-module-doc]), that is designed to be
hooked up to your own functions, mappings and autocmds.

The functions within are designed to "do the right thing" with little to no
configuration. You shouldn't need them in normal use, but they may come in
useful when you need to fit nfnl into an interesting workflow or system.

As an example, here's how and why you'd use the `compile-all-files` function
from another Fennel file to, you guessed it, compile all of your files.

```fennel
(local nfnl (require :nfnl.api))

;; Takes an optional directory as an argument, defaults to (vim.fn.getcwd).
(nfnl.compile-all-files)
```

In the case where you're absolutely adamant that you need to `.gitignore` your
compiled Lua output, this can be used after you `git pull` to ensure everything
is compiled. However, I strongly advise committing your Lua for performance
_and_ stability.

This project was designed around the principal of compiling early and then never
needing to compile again unless you make changes. I thought long and hard about
the tradeoffs so you don't have to. These tools are here for when I'm wrong.

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

Remember to rebuild the API documentation and run the tests when making changes.
This workflow will be automated and streamlined eventually.

## Testing

Tests are written under `fnl/spec/nfnl/**/*_spec.fnl`. They're compiled into the
`lua/` directory by nfnl itself and executed by [Plenary][plenary], you must
have this plugin installed in order to run the test suite within Neovim.

The project local `.nfnl.fnl` defines the `<localleader>pt` mapping which allows
you to execute the test suite from within Neovim using Plenary.

To run the tests outside of your configuration you can run
`./script/setup-test-deps` (installs dependencies into this local directory) and
then `./script/test` to execute the tests in a headless local Neovim
configuration.

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

`script/fenneldoc.lua` is also excluded since it's compiled from the
[fenneldoc][fenneldoc] repository.

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
[fenneldoc]: https://gitlab.com/andreyorst/fenneldoc
[telescope]: https://github.com/nvim-telescope/telescope.nvim
[neotree]: https://github.com/nvim-neo-tree/neo-tree.nvim
[astronvim]: https://astronvim.com/
[plenary]: https://github.com/nvim-lua/plenary.nvim
[apidoc]: https://github.com/Olical/nfnl/tree/main/docs/api/nfnl
[nvim-local-fennel]: https://github.com/Olical/nvim-local-fennel
[sd]: https://github.com/chmln/sd
[fd]: https://github.com/sharkdp/fd
[nfnl-plugin-example]: https://github.com/Olical/nfnl-plugin-example
[lua-in-git-justifications]: https://github.com/Olical/nfnl/issues/5#issuecomment-1655447175
[api-module-doc]: https://github.com/Olical/nfnl/blob/main/docs/api/nfnl/api.md
[config-default-doc]: https://github.com/Olical/nfnl/blob/main/docs/api/nfnl/config.md#default
