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

**Exercise 3.4** Define a function _applyAll_ that, given a list of functions [_f1_, _f2_, ... , _fn_] and a value _v_, returns the result _f1_(_f2_(...(_fn v_))). For example:

_applyAll_ [_simple_ 2 2, (+3)] 5 => 20

```haskell
applyAll :: [a -> a] -> a -> a
applyAll fs x = let apply f y = f y
                in foldr apply x fs
```
