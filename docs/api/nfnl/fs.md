# Fs.fnl

**Table of contents**

- [`basename`](#basename)
- [`file-name-root`](#file-name-root)
- [`filename`](#filename)
- [`findfile`](#findfile)
- [`fnl-path->lua-path`](#fnl-path-lua-path)
- [`full-path`](#full-path)
- [`glob-dir-newer?`](#glob-dir-newer)
- [`join-path`](#join-path)
- [`mkdirp`](#mkdirp)
- [`path-sep`](#path-sep)
- [`read-first-line`](#read-first-line)
- [`relglob`](#relglob)
- [`replace-dirs`](#replace-dirs)
- [`replace-extension`](#replace-extension)
- [`split-path`](#split-path)

## `basename`
Function signature:

```
(basename path)
```

**Undocumented**

## `file-name-root`
Function signature:

```
(file-name-root path)
```

**Undocumented**

## `filename`
Function signature:

```
(filename path)
```

Just the filename / tail of a path.

## `findfile`
Function signature:

```
(findfile name path)
```

Wrapper around Neovim's findfile() that returns nil
  instead of an empty string.

## `fnl-path->lua-path`
Function signature:

```
(fnl-path->lua-path fnl-path)
```

**Undocumented**

## `full-path`
Function signature:

```
(full-path path)
```

**Undocumented**

## `glob-dir-newer?`
Function signature:

```
(glob-dir-newer? a-dir b-dir expr b-dir-path-fn)
```

Returns true if a-dir has newer changes than b-dir. All paths from a-dir are mapped through b-dir-path-fn before comparing to b-dir.

## `join-path`
Function signature:

```
(join-path parts)
```

**Undocumented**

## `mkdirp`
Function signature:

```
(mkdirp dir)
```

**Undocumented**

## `path-sep`
Function signature:

```
(path-sep)
```

**Undocumented**

## `read-first-line`
Function signature:

```
(read-first-line path)
```

**Undocumented**

## `relglob`
Function signature:

```
(relglob dir expr)
```

Glob all files under dir matching the expression and return the paths
  relative to the dir argument.

## `replace-dirs`
Function signature:

```
(replace-dirs path from to)
```

Replaces directories in `path` that match `from` with `to`.

## `replace-extension`
Function signature:

```
(replace-extension path ext)
```

**Undocumented**

## `split-path`
Function signature:

```
(split-path path)
```

**Undocumented**


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
