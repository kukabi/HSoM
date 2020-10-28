### Chapter 02: Polymorphic and Higher-Order Functions

Solution, application and examples are in [app/Main.hs](./app/Main.hs). You can run it with `stack run` in this folder.

**Exercise 3.1** Using _map_, define:

1. A function _f1 :: Int -> [Pitch] -> [Pitch]_ that transposes each pitch in its second argument by the amount specified in its first argument.

    ```haskell
    f1 :: Int -> [Pitch] -> [Pitch]
    f1 i ps = let f p = pitch (absPitch p + i)
              in map f ps
    ```

2. A function _f2 :: Dur -> [Music a]_ that turns a list of durations into a list of rests, each having the corresponding duration.

    ```haskell
    f2 :: [Dur] -> [Music a]
    f2 ds = let f d = Prim (Rest d)
            in map f ds
    ```

3. A function _f3 :: [Music Pitch] -> [Music Pitch]_ that takes a list of music values (that are assumed to be single notes) and for each such note, halves its duration and places a rest of that same duration after it.

    ```haskell
    -- assumes all values are single notes
    f3 :: [Music Pitch] -> [Music Pitch]
    f3 ms = let f (Prim (Note d p)) = Prim (Note (d / 2) p) :+: Prim (Rest (d / 2))
            in map f ms
    ```

**Exercise 3.2** Show that _flip (flip f)_ is the same as _f_.

```
flip (flip f x y)
=> flip (f y x)
=> f x y
```

**Exercise 3.3** Define the type of _ys_ in:

_xs_ = [1, 2, 3] :: [Integer]
_ys_ = _map_ (+) _xs_

```
(+) with a single argument becomes a partially applied function.
So we can think of ys as an array of partially applied functions,
each of them a function that adds to the given parameter the corresponding
integer value in the array. So the type can be shown as:

ys :: [Integer -> Integer]
```

**Exercise 3.4** Define a function _applyEach_ that, given a list of functions, applies each to some given value. For example:

_applyEach_ [_simple_ 2 2, (+3)] 5 => [14, 8]

where _simple_ is as defined in Chapter 1.

```haskell
applyEach :: [a -> b] -> a -> [b]
applyEach [] _ = []
applyEach (f:fs) x = f x : (applyEach fs x)
```

**Exercise 3.5** Define a function _applyAll_ that, given a list of functions [_f1_, _f2_, ... , _fn_] and a value _v_, returns the result _f1_(_f2_(...(_fn v_))). For example:

_applyAll_ [_simple_ 2 2, (+3)] 5 => 20

```haskell
applyAll :: [a -> a] -> a -> a
applyAll fs x = let apply f y = f y
                in foldr apply x fs
```

**Exercise 3.6** Recall the discussion about the efficiency of (++) and _concat_ in Chapter 3. Which of the following functions is more efficient, and why?

_appendr, appendl_ :: \[\[_a_\]\] -> \[_a_\]\
_appendr_ = _foldr_ (_flip_ (++)) []
_appendl_ = _foldl_ (_flip_ (++)) []

_appendl_ becomes the same as concat, and _appendr_ same as slowConcat as shown below.

```
appendl = foldl (flip (++)) []
appendl [xs1, xs2, ..., xsn]
=> foldl (flip (++)) [] [xs1, xs2, ..., xsn]
=> (...(([] (flip (++)) xs1) (flip (++)) xs2)...) (flip (++)) xsn
=> xsn ++ (...(xs2 ++ (xs1 ++ []))...)

appendr = foldr (flip (++)) []
appendr [xs1, xs2, ..., xsn]
=> foldr (flip (++)) [] [xs1, xs2, ..., xsn]
=> xs1 (flip (++)) (xs2 (flip (++)) (...(xsn (flip (++)) []))...)
=> (...([] ++ xsn)...) ++ xs2) ++ xs1
```

Cost of _appendl_ is the sum of the lengths of the lists:

_cost<sub>appendl</sub>_ = _ℓ<sub>1</sub>_ + _ℓ<sub>2</sub>_ + ... + _ℓ<sub>n - 1</sub>_

Cost of _appendr_ is considerable worse than _appendl_:

_cost<sub>appendr</sub>_ = _(n - 1) \* ℓ<sub>1</sub>_ + _(n - 2) \* ℓ<sub>2</sub>_ + ... + _2 \* ℓ<sub>n - 2</sub> + ℓ<sub>n - 1</sub>_

_appendl_ is the more efficient one.

**Exercise 3.7** Rewrite the definition of _length_ non-recursively.

```haskell
length :: [a] -> Int
length [] = 0
length (x:xs) = 1 + length xs
```

**Exercise 3.8** Define a function that behaces as each of the following:

1. Doubles each number in a list.

    ```haskell
    doubleEach = map (*2)
    ```

2. Pairs each element in a list with that number and one plus that number.

    ```haskell
    pairAndOne = let f x = (x, x + 1)
                 in map f
    ```

3. Adds together each pair of numbers in a list.

    ```haskell
    addEachPair = let f (x, y) = x + y
                  in map f
    ```

4. Adds "pointwise" the elements of a list of pairs.

    ```haskell
    addPairsPointwise = let f (a, b) (c, d) = (a + c, b + d)
                        in foldr f (0, 0)
    ```
