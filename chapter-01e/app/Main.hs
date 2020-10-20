module Main where

import Euterpea

{-
Exercise 1.4 Modify the definitions of `hnote` and `hList` so that they each take an extra
argument that specifies the interval of harmonization (rather than being fixed at -3).
Rewrite the definition of `mel`to take these changes into account.
-}
hNote :: Dur -> Pitch -> AbsPitch -> Music Pitch
hNote d p i = note d p :=: note d (trans i p) -- i for interval

hList :: Dur -> [Pitch] -> AbsPitch -> Music Pitch
hList d [] _ = rest 0
hList d (p : ps) i = hNote d p i :+: hList d ps i -- i for interval

maj3 :: AbsPitch
maj3 = 4 -- major 3rd interval is 4 semitones
-- a simple harmonized melody in c major
cMajorMelody = hList hn [(C, 4), (F, 4), (G, 4)] maj3 
                    :+: hNote wn (C, 4) maj3

main = play cMajorMelody