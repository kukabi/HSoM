module Main where

import Euterpea

-- example melody
melodyPitches :: [Pitch]
melodyPitches = [(C, 4), (D, 4), (E, 4), (D, 4), (G, 4), (C, 4), (C, 4)]

-- helper function
pitchToMusic :: Dur -> Pitch -> Music Pitch
pitchToMusic d p = Prim (Note d p)

-- helper var
melodyMusics :: [Music Pitch]
melodyMusics = let f p = pitchToMusic qn p
               in map f melodyPitches

-- helper function
pitchesToLine :: Dur -> [Pitch] -> Music Pitch
pitchesToLine _ [] = Prim (Rest 0)
pitchesToLine d (p:ps) = Prim (Note d p) :+: pitchesToLine d ps

-- helper function
musicsToLine :: [Music Pitch] -> Music Pitch
musicsToLine [] = Prim (Rest 0)
musicsToLine (mp:mps) = mp :+: musicsToLine mps

{-
Exercise 3.1 Using map, define:
-}

{-
1. A function f1 :: Int -> [Pitch] -> [Pitch] that transposes each pitch
in its second argument by the amount specified in its first argument.
-}
f1 :: Int -> [Pitch] -> [Pitch]
f1 i ps = let f p = pitch (absPitch p + i)
          in map f ps

{-
2. A function f2 :: Dur -> [Music a] that turns a list of durations
into a list of rests, each having the corresponding duration.
-}
f2 :: [Dur] -> [Music a]
f2 ds = let f d = Prim (Rest d)
        in map f ds

{-
3. A function f3 :: [Music Pitch] -> [Music Pitch] that takes a list
of music values (that are assumed to be single notes) and for each
such note, halves its duration and places a rest of that same duration
after it.
-}
-- assumes all values are single notes!
f3 :: [Music Pitch] -> [Music Pitch]
f3 ms = let f (Prim (Note d p)) = Prim (Note (d / 2) p) :+: Prim (Rest (d / 2))
        in map f ms

melody :: Music Pitch
melody = pitchesToLine qn melodyPitches
transposedMelody :: Music Pitch
transposedMelody = pitchesToLine qn (f1 2 melodyPitches)
melodyWithRests :: Music Pitch
melodyWithRests = musicsToLine (f3 melodyMusics)

{-
Exercise 3.4 Define a function applyEach that, given a list of functions,
applies each to some given value.
-}
applyEach :: [a -> b] -> a -> [b]
applyEach [] _ = []
applyEach (f:fs) x = f x : (applyEach fs x)

{-
Exercise 3.5 Define a function applyAll that, given a list of
functions [f1, f2, ... , fn] and a value v, 
eturns the result f1(f2( ... (fn v))).
-}
applyAll :: [a -> a] -> a -> a
applyAll fs x = let apply f y = f y
                in foldr apply x fs

simple x y z = x * (y + z)
applyEachResult = applyEach [simple 2 2, (+3)] 5
applyAllResult = applyAll [simple 2 2, (+3)] 5

main = do
    print "Playing plain melody ..."
    play melody
    print "Playing transposed melody ..."
    play transposedMelody
    print "Playing melody with rests ..."
    play melodyWithRests
    print "applyEach [simple 2 2, (+3)] 5 is:"
    print applyEachResult
    print "applyAll [simple 2 2, (+3)] 5 is:"
    print applyAllResult