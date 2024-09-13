# String.fnl

**Table of contents**

- [`blank?`](#blank)
- [`ends-with?`](#ends-with)
- [`join`](#join)
- [`split`](#split)
- [`trim`](#trim)
- [`triml`](#triml)
- [`trimr`](#trimr)

## `blank?`
Function signature:

```
(blank? s)
```

Check if the string is nil, empty or only whitespace.

## `ends-with?`
Function signature:

```
(ends-with? s suffix)
```

Check if the string ends with suffix.

## `join`
Function signature:

```
(join ...)
```

(join xs) (join sep xs)
  Joins all items of a table together with an optional separator.
  Separator defaults to an empty string.
  Values that aren't a string or nil will go through nfnl.core/pr-str.

## `split`
Function signature:

```
(split s pat)
```

Split the given string into a sequential table using the pattern.

## `trim`
Function signature:

```
(trim s)
```

Removes whitespace from both ends of string.

## `triml`
Function signature:

```
(triml s)
```

Removes whitespace from the left side of string.

## `trimr`
Function signature:

```
(trimr s)
```

Removes whitespace from the right side of string.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
