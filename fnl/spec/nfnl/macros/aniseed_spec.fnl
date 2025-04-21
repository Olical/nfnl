(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(import-macros
  {: module
   : def- : def
   : defn- : defn
   : defonce- : defonce}
  :nfnl.macros.aniseed)

(module spec.nfnl.macros.aniseed-example)

(def- private-val "this is private")
(def public-val "this is public")

(defn- private-fn [] "this is private fn")
(defn public-fn [] "this is public fn")

(defonce- private-once-val "this is private once val")
(defonce- private-once-val "this is ignored")

(defonce public-once-val "this is public once val")
(defonce public-once-val "this is ignored")

(local mod (require :spec.nfnl.macros.aniseed-example))

(describe "def-"
  (fn []
    (it "defines private values"
      (fn []
        (assert.equals "this is private" private-val)
        (assert.equals nil (. mod :private-val))))))

(describe "def"
  (fn []
    (it "defines public values"
      (fn []
        (assert.equals "this is public" public-val)
        (assert.equals "this is public" (. mod :public-val))))))

(describe "defn-"
  (fn []
    (it "defines private functions"
      (fn []
        (assert.equals "this is private fn" (private-fn))
        (assert.equals nil (. mod :private-fn))))))

(describe "defn"
  (fn []
    (it "defines public functions"
      (fn []
        (assert.equals "this is public fn" (public-fn))
        (assert.equals "this is public fn" ((. mod :public-fn)))))))

(describe "defonce-"
  (fn []
    (it "defines private once values"
      (fn []
        (assert.equals "this is private once val" private-once-val)
        (assert.equals nil (. mod :private-once-val))))))

(describe "defonce"
  (fn []
    (it "defines public once values"
      (fn []
        (assert.equals "this is public once val" public-once-val)
        (assert.equals "this is public once val" (. mod :public-once-val))))))
