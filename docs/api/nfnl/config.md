# Config.fnl

**Table of contents**

- [`cfg-fn`](#cfg-fn)
- [`config-file-path?`](#config-file-path)
- [`default`](#default)
- [`find`](#find)
- [`find-and-load`](#find-and-load)

## `cfg-fn`
Function signature:

```
(cfg-fn t opts)
```

Builds a cfg fetcher for the config table t. Returns a function that takes a
  path sequential table, it looks up the value from the config with core.get-in
  and falls back to a matching value in (default) if not found.

## `config-file-path?`
Function signature:

```
(config-file-path? path)
```

**Undocumented**

## `default`
Function signature:

```
(default opts)
```

Returns the default configuration that you should base your custom
  configuration on top of. Feel free to call this with no arguments and merge
  your changes on top. If you wish, you can override opts.root-dir (which
  defaults to the dir of your .nfnl.fnl project root and the CWD as a backup)
  to whatever you need. The defaults with no arguments should be exactly what
  you need in most cases though.

  Make sure you update the README whenever you change the default
  configuration!

## `find`
Function signature:

```
(find dir)
```

Find the nearest .nfnl.fnl file to the given directory. Returns the absolute
  path to the found file or nil.

## `find-and-load`
Function signature:

```
(find-and-load dir)
```

Attempt to find and load the .nfnl.fnl config file relative to the given dir.
  Returns an empty table when there's issues or if there isn't a config file.
  If there's some valid config you'll get table containing config, cfg (fn) and
  root-dir back.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
