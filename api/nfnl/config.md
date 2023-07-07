# Config.fnl

**Table of contents**

- [`default-config`](#default-config)
- [`find-and-load`](#find-and-load)

## `default-config`
Function signature:

```
(default-config)
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
