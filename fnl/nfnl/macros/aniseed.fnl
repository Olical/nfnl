;; [nfnl-macro]

;; Copied over from Aniseed. Contains all of the def* module macro systems.
;; https://github.com/Olical/aniseed

;; This has been heavily slimmed down from the original implementation, the
;; `(module ...) macro can now ONLY define your module, it can not be used
;; to require dependencies.

;; We had to slim things down because the Fennel compiler no longer supports
;; the weird tricks we were using.

;; In nfnl they are not automatically required, you must use import-macros to
;; require them explicitly when migrating your Aniseed based projects.

;; Various symbols we want to use multiple times.
;; Avoids the compiler complaining that we're introducing locals without gensym.
(local mod-name-str :*module-name*)
(local mod-name-sym (sym mod-name-str))
(local mod-str :*module*)
(local mod-sym (sym mod-str))

;; Upserts the existence of the module for subsequent def forms.
;;
;; On subsequent interactive calls it will expand the existing module into your
;; current context. This should be used by Conjure as you enter a buffer.
;;
;; (module foo
;;   {:some-optional-base :table-of-things
;;    :to-base :the-module-off-of})
;;
;; (module foo) ;; expands foo into your current context
(fn module [mod-name mod-fns mod-base]
  (let [;; So we can check for existing values and know if we're in an interactive eval.
        ;; If the module doesn't exist we're compiling and can skip interactive tooling.
        existing-mod (. _G.package.loaded (tostring mod-name))

        ;; Determine if we're in an interactive eval or not.

        ;; We don't count userdata / other types as an existing module since we
        ;; can't really work with anything other than a table. If it's not a
        ;; table it's probably not a module Aniseed can work with in general
        ;; since it's assumed all Aniseed modules are table based.
        interactive? (table? existing-mod)]


    `(local
       (,mod-name-sym
        ,mod-sym)
       (;; Module name accessible under the module name symbol.
        ,(tostring mod-name)

        ;; Only expose the module table if it doesn't exist yet.
        ,(if interactive?
          `(. _G.package.loaded ,mod-name-sym)
          `(do
              (tset _G.package.loaded ,mod-name-sym ,(or mod-base {}))
              (. _G.package.loaded ,mod-name-sym)))))))

(fn def- [name value]
  `(local ,name ,value))

(fn def [name value]
  `(local ,name (do (tset ,module-sym ,value) (. ,module-sym ,(tostring name)))))

(fn defn- [name ...]
  `(fn ,name ,...))

(fn defn [name ...]
  `(def ,name (fn ,name ,...)))

(fn defonce- [name value]
  `(def- ,name (or ,name ,value)))

(fn defonce [name value]
  `(def ,name (or (. ,mod-sym ,(tostring name)) ,value)))

{:module module
 :def- def- :def def
 :defn- defn- :defn defn
 :defonce- defonce- :defonce defonce}
