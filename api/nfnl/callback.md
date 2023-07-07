# Callback.fnl

**Table of contents**

- [`fennel-filetype-callback`](#fennel-filetype-callback)

## `fennel-filetype-callback`
Function signature:

```
(fennel-filetype-callback ev)
```

Called whenever we enter a Fennel file. It walks up the tree to find a
  .nfnl.fnl (which can contain configuration). If found, we initialise the
  compiler autocmd for the directory containing the .nfnl.fnl file.

  This allows us to edit multiple projects in different directories with
  different .nfnl.fnl configuration, wonderful!


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
