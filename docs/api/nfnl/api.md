# Api.fnl

**Table of contents**

- [`compile-all-files`](#compile-all-files)
- [`compile-file`](#compile-file)
- [`delete-orphans`](#delete-orphans)
- [`dofile`](#dofile)
- [`find-orphans`](#find-orphans)

## `compile-all-files`
Function signature:

```
(compile-all-files dir)
```

Compiles all files in the given dir (optional), defaulting to the current working directory. Returns a sequential table with each of the files compilation result.

  Will do nothing if you execute it on a directory that doesn't contain an nfnl configuration file.

  Also displays all results via the notify system.

## `compile-file`
Function signature:

```
(compile-file {:dir dir :path path})
```

Compiles a file into the matching Lua file. Returns the compilation result. Takes an optional `dir` key that changes the working directory.

  Will do nothing if you execute it on a directory that doesn't contain an nfnl configuration file.

  Also displays all results via the notify system.

## `delete-orphans`
Function signature:

```
(delete-orphans {:dir dir})
```

Delete orphan Lua files that were compiled from a Fennel file that no longer exists.

## `dofile`
Function signature:

```
(dofile file)
```

Just like :luafile, takes a Fennel file path (optional, defaults to '%', runs it through expand) and executes it from disk. However! This doesn't compile the Fennel! It maps the Fennel path to the matching Lua file already in your file system and executes that with Lua's built in dofile. So you need to have already written your .fnl and had nfnl compile that to a .lua for this to work, it's just a convinience function for you to call directly or through the :NfnlFile command.

## `find-orphans`
Function signature:

```
(find-orphans {:dir dir :passive? passive?})
```

Find orphan Lua files that were compiled from a Fennel file that no longer exists. Display them with notify. Set opts.passive? to true if you don't want it to tell you that there are no orphans.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
