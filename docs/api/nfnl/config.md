# Config.fnl

**Table of contents**

- [`cfg-fn`](#cfg-fn)
- [`config-file-path?`](#config-file-path)
- [`default`](#default)
- [`find-and-load`](#find-and-load)

## `cfg-fn`
Function signature:

```
(cfg-fn t)
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
(default)
```

**Undocumented**

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
