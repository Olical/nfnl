(describe
  "some basics"
  (fn []
    (fn bello [boo] (.. "bello " boo))

    (var bounter nil)

    (before_each
      (fn [] (set bounter 0)))

    (it
      "some test"
      (fn [] (set bounter 100)
        (assert.equals "bello Brian" (bello :Brian))))

    (it
      "some other test"
      (fn [] (assert.equals 0 bounter)))))	
