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

**Exercise 3.9** Define a polymorphic function _fuse :: [Dur] -> [Dur -> Music a] -> [Music a]_ that combines a list of durations with a list of notes lacking a duration, to create a list of complete notes. For example:

_fuse [qn, hn, sn] [c 4, d 4, e 4]_\
=> _[c 4 qn, d 4 hn, e 4 sn]_

You may signal an error if the lists have unequal lengths.

```haskell
fuse :: [Dur] -> [Dur -> Music a] -> [Music a]
fuse (d:ds) (n:ns) = n d : (fuse ds ns)
fuse [] [] = []
fuse [] (f:fs) = error "Unequal lengths -- note array is longer."
fuse (d:ds) [] = error "Unequal lengths -- duration array is longer."
```

**Exercise 3.10** Define a function _maxAbsPitch_ that determines the maximum absolute pitch of a list of absolute pitches. Define _minAbsPitch_ analogously. Both functions should return an error if applied to the empty list.

```haskell
-- non-recursive
maxAbsPitch :: [AbsPitch] -> AbsPitch
maxAbsPitch = foldr1 max

-- recursive
maxAbsPitchR :: [AbsPitch] -> AbsPitch
maxAbsPitchR [] = error "Empty array for maxAbsPitchR!"
maxAbsPitchR [ap] = ap
maxAbsPitchR (ap:aps) = if ap > maxAbsPitchR aps then ap else maxAbsPitchR aps
```

**Exercise 3.11** Define a function _chrom :: Pitch -> Pitch -> Music Pitch_ such that _chrom p1 p2_ is a chromatic scale of quarter-notes whose first pitch is _p1_ and last pitch is _p2_. If _p1_ > _p2_, the scale should be descending, otherwise it should be ascending. If _p1_ == _p2_, then the scale should contain just one note. (A chromatic scale is one whose successive pitches are separated by one absolute pitch (i.e. one semitone)).

```haskell
-- recursive
chromR :: Pitch -> Pitch -> Music Pitch
chromR p1 p2 = if absPitch p1 == absPitch p2
               then note qn p1
               else note qn p1 :+:
               if absPitch p1 < absPitch p2
               then chromR (trans 1 p1) p2
               else chromR (trans (-1) p1) p2
```

**Exercise 3.12** Abstractly, a scale can be described by the intervals between successive notes. For example, the 7-note major scale can be defined as the sequence of 6 intervals [ 2, 2, 1, 2, 2, 2 ], and the 12-note chromatic scale by the 11 intervals [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]. Define a function _mkScale :: Pitch -> [Int] -> Music Pitch_ such that _mkScale p ints_ is the scale beginning at pitch _p_ and having the intervallic structure _ints_.

```haskell
mkScale :: Pitch -> [Int] -> Music Pitch
mkScale p [] = note qn p
mkScale p (i:is) = note qn p :+: mkScale (trans i p) is
```

**Exercise 3.13** Define an enumerated data type that captures each of the standard major scale modes: Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aeolian, and Locrian. Then define a function _genScale_ that, given one of these contructors, generates a scale in the intervalic form described in Exercise 3.12.

```haskell
-- note: the type Mode and enumerations are defined in Euterpea, so I prefix
-- all with M
data MajorMode =
    MIonian
    | MDorian
    | MPhrygian
    | MLydian
    | MMixolydian
    | MAeolian
    | MLocrian

genScale :: MajorMode -> [Int]
genScale mode = case mode of
    MIonian -> [2, 2, 1, 2, 2, 2]
    MDorian -> [2, 1, 2, 2, 2, 1]
    MPhrygian -> [1, 2, 2, 2, 1, 2]
    MLydian -> [2, 2, 2, 1, 2, 2]
    MMixolydian -> [2, 2, 1, 2, 2, 1]
    MAeolian -> [2, 1, 2, 2, 1, 2]
    MLocrian -> [1, 2, 2, 1, 2, 2]
```
