(local module-key :nfnl/autoload-module)
(local enabled-key :nfnl/autoload-enabled?)

(fn autoload [name]
  "Like autoload from Vim Script! A replacement for require that will load the
  module when you first use it.

  (local autoload (require :nfnl.autoload))
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

autoload
