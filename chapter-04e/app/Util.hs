module Util (addDur, graceNote, quickGraceNote, prefixes, mordent, quickMordent) where

import Euterpea

-- adds duration to an array of durationless notes (e.g. c 5)
addDur :: Dur -> [Dur -> Music Pitch] -> Music Pitch
addDur d ns = let f n = n d
              in line (map f ns)

-- inserts a grace note 1/8th of the duration of the note
graceNote :: Int -> Music Pitch -> Music Pitch
graceNote n (Prim (Note d p)) = Prim(Note (d / 8) (trans n p)) :+: Prim(Note (7 * d / 8) p)
graceNote n _ = error "Can only add a grace note to a note."

quickGraceNote :: Int -> Music Pitch -> Music Pitch
quickGraceNote n (Prim (Note d p)) = Prim(Note (d / 16) (trans n p)) :+: Prim(Note (15 * d / 16) p)
quickGraceNote n _ = error "Can only add a quick grace note to a note."

mordent :: Int -> Music Pitch -> Music Pitch
mordent n (Prim (Note d p)) = note (d / 4) p :+: note (d / 4) (trans n p) :+: note (d / 2) p
mordent n _ = error "Can only add a mordent to a note."

quickMordent :: Int -> Music Pitch -> Music Pitch
quickMordent n (Prim (Note d p)) = note (d / 6) p :+: note (d / 6) (trans n p) :+: note (2 * d / 3) p
quickMordent n _ = error "Can only add a quick mordent to a note."

-- the array prefix function
prefixes :: [a] -> [[a]]
prefixes [] = []
prefixes (x:xs) = let f pf = x : pf
                  in [x] : map f (prefixes xs)

-- the musical prefix function as defined in the book
prefix :: [Music a] -> Music a
prefix mel = let m1 = line (concat (prefixes mel))
                 m2 = transpose 12 (line (concat (prefixes (reverse mel))))
                 m = instrument Flute m1 :=: instrument VoiceOohs m2
             in m :+: transpose 5 m :+: m