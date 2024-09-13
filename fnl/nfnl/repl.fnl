(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local fennel (autoload :nfnl.fennel))
(local notify (autoload :nfnl.notify))
(local str (autoload :nfnl.string))

(fn new [opts]
  "Create a new REPL instance which is a function you repeatedly call with more
  code for evaluation. The results of the evaluations are returned in a table.
  Call with a nil instead of a string of code to close the REPL."
  (var results-to-return nil)

  (local co
    (coroutine.create
      (fn []
        (fennel.repl
          {:pp core.identity
           :readChunk coroutine.yield

           :onValues
           (fn [results]
             (set results-to-return (core.concat results-to-return results)))

           :onError
           (fn [err-type err lua-source]
             (if (?. opts :on-error)
               (opts.on-error err-type err lua-source)
               (notify.error (str.join "\n\n" [(.. "[" err-type "] " err) lua-source]))))}))))

  (coroutine.resume co)

  (fn [input]
    ;; Split the input into single characters and evaluate each, one at a time.
    ;; This is to ensure evaluating ":foo :bar" returns both values.
    (if (core.string? input) 
      (core.run!
        (fn [char]
          (coroutine.resume co char))
        (core.seq (.. input "\n")))
      (coroutine.resume co input))

    (let [prev-eval-values results-to-return]
      (set results-to-return nil)
      prev-eval-values)))

{: new}
