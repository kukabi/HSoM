### Chapter 01: Computer Music, Euterpea and Haskell

**Exercise 1.1** Write out all of the steps in the calculation of the value of `simple (simple 2 3 4) 5 6`.

```
simple (simple 2 3 4) 5 6
=> simple (2 * (3 + 4)) 5 6
=> simple (2 * 7) 5 6
=> simple 14 5 6
=> 14 * (5 + 6)
=> 14 * 11
=> 154
```

**Exercise 1.2** Prove by calculation that `simple (a - b) a b => a^2 - b^2`.

```
simple (a - b) a b
=> (a - b) * (a + b)
=> a * (a + b) - b * (a + b)
=> a^2 + (a * b) - b^2 - (b * a)
=> a^2 - b^2
```

**Exercise 1.3** Identify the well-typed expressions in the following and, for each, give its proper type.

```haskell
[A, B, C]                 :: [PitchClass]
[D, 42]                   -- ill-typed: cannot mix different types in a list
[(-42, Ef)]               :: [(Integer, PitchClass)]
[('a', 3), ('b', 5)]      :: [(Char, Integer)]
simple 'a' 'b' 'c'        -- ill-typed: simple functions accepts integers
(simple 1 2 3, simple)    -- ill-typed: second simple has no arguments
["I", "Love", "Euterpea"] :: [String]
```

`ghci` output (mind the `:set +t` switch, which makes the CLI show the types):

```
user@users-MacBook-Pro:~$ ghci
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
Prelude> :set +t
Prelude> import Euterpea
Prelude Euterpea> simple x y z = x * (y + z)
simple :: Num a => a -> a -> a -> a
Prelude Euterpea> [A, B, C]
[A,B,C]
it :: [PitchClass]
Prelude Euterpea> [D, 42]

<interactive>:5:5: error:
    • No instance for (Num PitchClass) arising from the literal ‘42’
    • In the expression: 42
      In the expression: [D, 42]
      In an equation for ‘it’: it = [D, 42]
Prelude Euterpea> [(-42, Ef)]
[(-42,Ef)]
it :: Num a => [(a, PitchClass)]
Prelude Euterpea> [('a', 3), ('b', 5)]
[('a',3),('b',5)]
it :: Num b => [(Char, b)]
Prelude Euterpea> simple 'a' 'b' 'c'

<interactive>:8:1: error:
    • No instance for (Num Char) arising from a use of ‘simple’
    • In the expression: simple 'a' 'b' 'c'
      In an equation for ‘it’: it = simple 'a' 'b' 'c'
Prelude Euterpea> (simple 1 2 3, simple)

<interactive>:9:1: error:
    • No instance for (Show (Integer -> Integer -> Integer -> Integer))
        arising from a use of ‘print’
        (maybe you haven't applied a function to enough arguments?)
    • In a stmt of an interactive GHCi command: print it
Prelude Euterpea> ["I", "Love", "Euterpea"]
["I","Love","Euterpea"]
it :: [[Char]]
```

**Exercise 1.4** Modify the definitions of `hnote` and `hList` so that they each take an extra argument that specifies the interval of harmonization (rather than being fixed at -3). Rewrite the definition of `mel`to take these changes into account.

Solution is in [app/Main.hs](./app/Main.hs). You can run it with `stack run` in this folder.
