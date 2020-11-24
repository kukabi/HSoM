### Chapter 05: Syntactic Magic

Some of the solutions are also in [Main.hs](./app/Main.hs).

**Exercise 5.1** Define a function _twice_ that, given a function _f_, returns a function that applies _f_ twice to its argument. For example:

_(twice (+1)) 2 => 4_

What is the principal type of _twice_? Describe what _twice twice_ does and give an example of its use. Also consider the functions _twice twice twice_ and _twice (twice twice)_.

```haskell
-- for f to be applied twice, the parameter type and
-- return type should be the same
twice :: (a -> a) -> a -> a
twice f a = f (f a)
```

_twice twice_ will apply the function to the parameter four times:

```
twice f a => f (f a)
twice twice f a => f (f (f (f a)))
```

**_twice twice twice_ applies the function sixteen times, yet I have not yet managed to understand why. Still working on it.**

**Exercise 5.2** Generalize _twice_ defined in the previous exercise by defining a function _power_ that takes a function _f_ and an integer _n_ and returns a functions that applies the function _f_ to its argument _n_ times. For example:

_power_ (+2) 5 1 => 11

Use _power_ in a musical context to define something useful.

```haskell
power :: (a -> a) -> Int -> a -> a
power f n a
    | n < 0     =  error "n cannot be less than 0."
    | n == 0    = a
    | otherwise = power f (n - 1) (f a)
```

We can use it to repeat a piece of music _n_ times:

```haskell
repeatN :: Int -> Music a -> Music a
repeatN 0 _ = rest 0
repeatN n m = power (:+: m) (n - 1) m
```

**Exercise 5.3** Suppose we define a function _fix_ as:

```haskell
fix f = f (fix f)
```

What is the principal type of _fix_?

-   _fix_ finds the fixed point of a function, where _f a = a_. Its type is _(a -> a) -> a_

Support further that we have a recursive function:

```haskell
remainder :: Integer -> Integer -> Integer
remainder a b = if a < b then a
                else remainder (a - b) b
```

Rewrite this function using _fix_ so that there is no recursive call to _remainder_. Do you think this process can be applied to _any_ recursive function?

```haskell
remainder' = fix (\f a b -> if a < b then a else f (a - b) b)
```

-   _Note: Something I don't understand here is that there actually is recursion in this definition._
-   Since the fixed point represents the base condition for a recursive call, yes, I think that _fix_ can be applied to any recursive function. An example:

    ```haskell
    sumNaturalNumbersUpTo :: Integer -> Integer
    sumNaturalNumbersUpTo 1 = 1
    sumNaturalNumbersUpTo n = n + sumNaturalNumbersUpTo (n - 1)
    sumNaturalNumbersUpTo' :: Integer -> Integer
    sumNaturalNumbersUpTo' = fix (\f a -> if a == 1 then a else a + f (a - 1))
    ```

**Exercise 5.4** Using list comprehensions, define a function:

_apPairs :: [AbsPitch] -> [AbsPitch] -> [(AbsPitch,AbsPitch)]_

such that _apPairs aps1 aps2_ is a list of all combinations of the absolute pitches in _aps1_ and _aps2_. Furthermore, for each pair _(ap1, ap2)_ in the result, the absolute value of _ap1 - ap2_ must be greater than two and less than eight.

```haskell
apPairs :: [AbsPitch] -> [AbsPitch] -> [(AbsPitch,AbsPitch)]
apPairs aps1 aps2 = [
        (ap1, ap2) |
            ap1 <- aps1,
            ap2 <- aps2,
            abs(ap1 - ap2) > 2,
            abs(ap1 - ap2) < 8
    ]
```

Finally, write a function to turn the result of _apPairs_ into a _Music Pitch_ value by playing each pair of pitches in parallel and stringing them all together sequentially. Try varying the rhythm by, for example, using an eighth note when the first absolute pitch is odd and a sixteenth note when it is even, or some other criterion. Test your functions by using arithmetic sequences to generate the two lists of arguments given to _apPairs_.

```haskell
musicalAPPairs :: [(AbsPitch,AbsPitch)] -> Music Pitch
musicalAPPairs pairs = let dur ap = if (ap `mod` 3 == 0) then sn else qn
                           pairToChord (ap1, ap2) =
                               chord [
                                   note (dur ap1) (pitch ap1),
                                   note (dur ap1) (pitch ap2)
                               ]
                       in line (map pairToChord pairs)
strangeWholeToneMusic = musicalAPPairs
                            (
                                apPairs
                                   [absPitch (C, 3), absPitch (D, 3)..absPitch (Gs, 4)]
                                   [absPitch (G, 3), absPitch (A, 3)..absPitch (Cs, 5)]
                            )
```

**Exercise 5.5** The last definition of _hList_ still has an argument _d_ on the left-hand side, and one occurence of _d_ on the right-hand side. Is there some way to eliminate it using currying simplification? (Hint: the answer is yes, but the solution is a bit perverse, and is not recommended as a way to write your code!)

```haskell
hList :: Dur -> [Pitch] -> Music Pitch
hList = (line .) . map . hNote
```

**Exercise 5.6** Use _line_, _map_ and ($) to give a concise definition of _addDur_.

```haskell
addDur :: Dur -> [Pitch] -> Music Pitch
addDur d ns = line $ map (\n -> n d) ns
```

**Exercise 5.7** Rewrite `map (\x -> (x + 1)/2)` xs using a composition of sections.

```haskell
map ((/2) . (+1)) xs
```

**Exercise 5.7** Consider the expression `map f (map g xs)`. Rewrite this using function composition and a single call to map.

```haskell
map (f . g) xs
```

Then rewrite the earlier example `map (\x -> (x + 1)/2) xs` as a “map of a map” (i.e. using two maps).

```haskell
map (/2) (map (+1) xs)
```

**Exercise 5.9** Go back to any exercises prior to this chapter, and simplify your solutions using ideas learned here.

_WiP_

**Exercise 5.10** Using higher-order functions introduced in this chapter, fill in the two missing functions, f1 and f2, in the evaluation below so that it is valid:

`f1 (f2 (*) [1,2,3,4]) 5 ⇒ [5,10,15,20]`

_WiP_
