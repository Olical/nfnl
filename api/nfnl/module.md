# Module.fnl

**Table of contents**

- [`autoload`](#autoload)

## `autoload`
Function signature:

```
(autoload name)
```

Like autoload from Vim Script! A replacement for require that will load the
  module when you first use it.

  (local autoload (require :nfnl.autoload))
  (local my-mod (autoload :my-mod))
  (my-mod.some-fn 10) ;; Your module is required here!

  It's a drop in replacement for require that should speed up your Neovim
  startup dramatically. Only works with table modules, if the module you're
  requiring is a function or anything other than a table you need to use the
  normal require.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
