# Api.fnl

**Table of contents**

- [`compile-all-files`](#compile-all-files)

## `compile-all-files`
Function signature:

```
(compile-all-files dir)
```

Compiles all files in the given dir (optional), defaulting to the current working directory. Returns a sequential table with each of the files compilation result.

  Will do nothing if you execute it on a directory that doesn't contain an nfnl configuration file.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
