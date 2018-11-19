
(defun countPrimes (n c)
  (if (n < 3)
    t
    (if (= t (isPrime n 2))
      (+ c (countPrimes (- n 1) (+ c 1)))
      (+ c (countPrimes (- n 1) c)
    )
  )
)