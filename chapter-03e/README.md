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
