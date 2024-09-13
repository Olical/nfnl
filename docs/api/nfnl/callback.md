# Callback.fnl

**Table of contents**

- [`fennel-filetype-callback`](#fennel-filetype-callback)
- [`supported-path?`](#supported-path)

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

## `supported-path?`
Function signature:

```
(supported-path? file-path)
```

Returns true if we can work with the given path. Right now we support a path if it's a string and it doesn't start with a protocol segment like fugitive://...


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
