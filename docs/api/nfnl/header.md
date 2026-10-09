# Header.fnl

**Table of contents**

- [`read`](#read)
- [`source-path`](#source-path)
- [`tagged?`](#tagged)
- [`with-header`](#with-header)

## `read`
Function signature:

```
(read path max-lines)
```

Search the first max-lines lines for an nfnl header. Returns the header and
  all preceding lines as a prefix (including their newlines). If no header is
  found, returns the first line, or nil for an empty or missing file.
  max-lines must be a positive integer.

## `source-path`
Function signature:

```
(source-path s)
```

**Undocumented**

## `tagged?`
Function signature:

```
(tagged? s)
```

Is the line an nfnl tagged header line? It must start with the exact prefix
  nfnl writes, so other comments that mention [nfnl] do not count.

## `with-header`
Function signature:

```
(with-header file src)
```

Return the source with an nfnl header prepended.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
