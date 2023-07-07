; (deftest if-let
;   (t.= :ok
;        (if-let [foo :ok]
;          foo
;          :nope))
;   (t.= :nope
;        (if-let [foo false]
;          :first
;          :nope))
;   (t.= :yes
;        (if-let [{: a} {:a 1}]
;          :yes
;          :no))
;   (t.= :no
;        (if-let [{: a} nil]
;          :yes
;          :no)))

; (deftest when-let
;   (t.= :ok
;        (when-let [foo :ok]
;          foo))
;   (t.= nil
;        (when-let [foo false]
;          :first))
;   (t.= :yarp
;        (when-let [(ok? val) (pcall #:yarp)]
;          val))
;   (t.= :yarp
;        (when-let [(_ val) (pcall #:yarp)]
;          val))
;   (t.= nil
;        (when-let [(ok? val) (pcall #(error :narp))]
;          val)))
