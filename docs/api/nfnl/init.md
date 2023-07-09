# Init.fnl

**Table of contents**

- [`compile-all-files`](#compile-all-files)
- [`setup`](#setup)

## `compile-all-files`
Function signature:

```
(compile-all-files dir)
```

**Undocumented**

## `setup`
Function signature:

```
(setup)
```

Called by the user or plugin manager at Neovim startup. Users may lazy load
  this plugin which means the Filetype autocmd already happened, so we have to
  check for that and manually invoke the callback for that case.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
