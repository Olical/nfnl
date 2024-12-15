(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local fennel (autoload :nfnl.fennel))
(local notify (autoload :nfnl.notify))
(local str (autoload :nfnl.string))

(fn new [opts]
  "Create a new REPL instance which is a function you repeatedly call with more
  code for evaluation. The results of the evaluations are returned in a table.
  Call with a nil instead of a string of code to close the REPL.

  Takes an opts table that can contain:
   * `on-error` - a function that will be called with the err-type, err and lua-source of any errors that occur in the REPL.
   * `cfg` - from cfg-fn in nfnl.config, will be used to configure the fennel instance with path strings before each evaluation."
  (var results-to-return nil)
  (local cfg (?. opts :cfg))

  (local co
    (coroutine.create
      (fn []
        (fennel.repl
          (core.merge!
            {:pp core.identity
             :readChunk coroutine.yield

             ;; Possible Fennel bug? We need to clone _G or multiple REPLs interfere with each other sometimes.
             :env (core.merge _G)

             :onValues
             (fn [results]
               (set results-to-return (core.concat results-to-return results)))

             :onError
             (fn [err-type err lua-source]
               (if (?. opts :on-error)
                 (opts.on-error err-type err lua-source)
                 (notify.error (str.trim (str.join "\n\n" [(.. "[" err-type "] " err) lua-source])))))}
            (when cfg
              (cfg [:compiler-options])))))))

  (coroutine.resume co)

  (fn [input]
    (when cfg
      (set fennel.path (cfg [:fennel-path]))
      (set fennel.macro-path (cfg [:fennel-macro-path])))

    (coroutine.resume co input)

    (let [prev-eval-values results-to-return]
      (set results-to-return nil)
      prev-eval-values)))

{: new}
