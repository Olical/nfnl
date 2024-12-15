# Repl.fnl

**Table of contents**

- [`new`](#new)

## `new`
Function signature:

```
(new opts)
```

Create a new REPL instance which is a function you repeatedly call with more
  code for evaluation. The results of the evaluations are returned in a table.
  Call with a nil instead of a string of code to close the REPL.

  Takes an opts table that can contain:
   * `on-error` - a function that will be called with the err-type, err and lua-source of any errors that occur in the REPL.
   * `cfg` - from cfg-fn in nfnl.config, will be used to configure the fennel instance with path strings before each evaluation.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
