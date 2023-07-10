(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(import-macros {: if-let : when-let} :nfnl.macros)

(describe
  "if-let"
  (fn []
    (it "works like if + let"
        (fn []
          (assert.equals
            :ok
               (if-let [foo :ok]
                 foo
                 :nope))
          (assert.equals
            :nope
               (if-let [foo false]
                 :first
                 :nope))
          (assert.equals
            :yes
               (if-let [{: a} {:a 1}]
                 :yes
                 :no))
          (assert.equals
            :no
               (if-let [{: a} nil]
                 :yes
                 :no))))))

(describe
  "when-let"
  (fn []
    (it "works like when + let"
        (fn []
          (assert.equals
            :ok
            (when-let [foo :ok]
              foo))
          (assert.equals
            nil
            (when-let [foo false]
              :first))
          (assert.equals
            :yarp
            (when-let [(ok? val) (pcall #:yarp)]
              val))
          (assert.equals
            :yarp
            (when-let [(_ val) (pcall #:yarp)]
              val))
          (assert.equals
            nil
            (when-let [(ok? val) (pcall #(error :narp))]
              val))))))
