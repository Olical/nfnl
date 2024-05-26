(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local str (require :nfnl.string))

(describe
  "join"
  (fn []
    (it "joins things together"
        (fn []
          (assert.equals "foo, bar, baz" (str.join ", " ["foo" "bar" "baz"]))
          (assert.equals "foobarbaz" (str.join ["foo" "bar" "baz"]))
          (assert.equals "foobar" (str.join ["foo" nil "bar"]) "handle nils correctly")))))

(describe
  "split"
  (fn []
    (it "splits strings up"
        (fn []
          (assert.are.same [""] (str.split "" ","))
          (assert.are.same ["foo"] (str.split "foo" ","))
          (assert.are.same ["foo" "bar" "baz"] (str.split "foo,bar,baz" ","))
          (assert.are.same ["foo" "" "bar"] (str.split "foo,,bar" ","))
          (assert.are.same ["foo" "" "" "bar"] (str.split "foo,,,bar" ","))
          (assert.are.same ["foo" "baz"] (str.split "foobarbaz" "bar"))))))

(describe
  "blank?"
  (fn []
    (it "true if the string is nil or just whitespace"
        (fn []
          (assert.is_true (str.blank? nil))
          (assert.is_true (str.blank? ""))
          (assert.is_true (str.blank? " "))
          (assert.is_true (str.blank? "   "))
          (assert.is_true (str.blank? "   \n \n  "))
          (assert.is_true (not (str.blank? "   \n . \n  ")))))))

(describe
  "triml"
  (fn []
    (it "trims all whitespace from the left of the string"
        (fn []
          (assert.equals "" (str.triml ""))
          (assert.equals "foo" (str.triml "foo"))
          (assert.equals "foo" (str.triml "    foo"))
          (assert.equals "foo" (str.triml "  \n  foo"))
          (assert.equals "foo  " (str.triml "  \n  foo  "))))))

(describe
  "trimr"
  (fn []
    (it "trims all whitespace from the right of the string"
        (fn []
          (assert.equals "" (str.trimr ""))
          (assert.equals "foo" (str.trimr "foo"))
          (assert.equals "foo" (str.trimr "foo    "))
          (assert.equals "foo" (str.trimr "foo  \n  "))
          (assert.equals "  foo" (str.trimr "  foo  \n  "))))))

(describe
  "trim"
  (fn []
    (it "trims all whitespace from start end end of a string"
        (fn []
          (assert.equals "" (str.trim ""))
          (assert.equals "foo" (str.trim "foo"))
          (assert.equals "foo" (str.trim " \n foo \n \n    ") "basic")
          (assert.equals "" (str.trim "           ") "just whitespace")))))

(describe
  "ends-with?"
  (fn []
    (it "checks if a string ends with another string"
        (fn []
          (assert.is_true (str.ends-with? "foobarbaz" "baz"))
          (assert.is_true (str.ends-with? "foobarbaz" "arbaz"))
          (assert.is_true (str.ends-with? "foobarbaz" "foobarbaz"))
          (assert.is_false (str.ends-with? "foobarbaz" "foo"))
          (assert.is_false (str.ends-with? "foobarbaz" "barbazz"))))))
