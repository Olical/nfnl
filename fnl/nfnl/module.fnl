(local module-key :nfnl/autoload-module)
(local enabled-key :nfnl/autoload-enabled?)

(local M {})

(fn M.autoload [name]
  "Like autoload from Vim Script! A replacement for require that will load the
  module when you first use it.

  (local {: autoload} (require :nfnl.module))
  (local my-mod (autoload :my-mod))
  (my-mod.some-fn 10) ;; Your module is required here!

  It's a drop in replacement for require that should speed up your Neovim
  startup dramatically. Only works with table modules, if the module you're
  requiring is a function or anything other than a table you need to use the
  normal require."

  (let [res {enabled-key true
             module-key false}
        ensure (fn []
                 (if (. res module-key)
                   (. res module-key)
                   (let [m (require name)]
                     (tset res module-key m)
                     m)))]

    (setmetatable
      res

      {:__call
       (fn [t ...]
         ((ensure) ...))

       :__index
       (fn [t k]
         (. (ensure) k))

       :__newindex
       (fn [t k v]
         (tset (ensure) k v))})))

(fn M.define [mod-name base]
  "Looks up the mod-name in package.loaded, if it's the same type as base it'll
  use the loaded value. If it's different it'll use base.

  The returned result should be used as your default value for M like so:
  (local M (define :my.mod {}))

  Then return M at the bottom of your file and define functions on M like so:
  (fn M.my-fn [x] (+ x 1))

  This technique helps you have extremely reloadable modules through Conjure.
  You can reload the entire file or induvidual function definitions and the
  changes will be reflected in all other modules that depend on this one
  without having to reload the dependant modules."

  (let [loaded (. package.loaded mod-name)]
    (if (= (type loaded) (type base))
      loaded
      base)))

M
