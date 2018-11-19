(defvar q (make-hash-table))

(defun isPrime (n)
  (if (gethash n q)
    t
    (checkPrime n)
  )
)

(defun checkPrime (n &optional (i 2))
  (if (= n i)
    (setf (gethash n q) t)
    (if (= (mod n i) 0)
      (setf (gethash n q) nil)
      (checkPrime n (+ i 1))
    )
  )
)

(defun rotate (n)
  (setq s "")
  (setq s (write-to-string n))
  (if (= 1 (length s))
    s
    (setq s (concatenate 'string (subseq s 1) (string (char s 0))))
  )
)



(defun rotateAll (n i &optional (prime t) (l '()))
  (setq s "")
  (setq s (rotate n))
  (if (find #\0 s)
    nil
    (if (= i 0)
      t
      (if (not (isPrime n))
        nil
        (rotateAll  (parse-integer s) (- i 1) l)
      )
    )
  )
)

(defun countSpecialPrimes (n &optional (c 0))
  (if (< n 2)
    c
    (if (isPrime n)
      (if (rotateAll n (intLength n))
        (countSpecialPrimes (- n 1) (+ c 1))
        (countSpecialPrimes (- n 1) c) 
      )
      (countSpecialPrimes (- n 1) c)
    )
  )
)

(defun intLength (n)
  (setq s (write-to-string n))
  (length s)
)