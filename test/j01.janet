# Assembly test
# Fibonacci sequence, implemented with naive recursion.
# a679f60
(def fibasm (asm '{
  :arity 1
  :bytecode [
    (ltim 1 0 0x2)      # $1 = $0 < 2
    (jmpif 1 :done)     # if ($1) goto :done
    (lds 1)             # $1 = self
    (addim 0 0 -0x1)    # $0 = $0 - 1
    (push 0)            # push($0), push argument for next function call
    (call 2 1)          # $2 = call($1)
    (addim 0 0 -0x1)    # $0 = $0 - 1
    (push 0)            # push($0)
    (call 0 1)          # $0 = call($1)
    (add 0 0 2)        # $0 = $0 + $2 (integers)
    :done
    (ret 0)             # return $0
  ]
}))

(defn fib [n] (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))

# these have similar performance, probably fibasm is a bit faster
(print (fibasm 40))
# (print (fib 40))

# $ time build/janet /workspaces/lc3-cc/test/j01.janet
# > 102334155
# > real    0m12.288s
