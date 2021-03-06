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
returns the result f1(f2( ... (fn v))).
-}
applyAll :: [a -> a] -> a -> a
applyAll fs x = let apply f y = f y
                in foldr apply x fs

simple x y z = x * (y + z)
applyEachResult = applyEach [simple 2 2, (+3)] 5
applyAllResult = applyAll [simple 2 2, (+3)] 5

{-
Exercise 3.7 Rewrite the definition of _length_ non-recursively.
-}
lengthNonRecursive :: [a] -> Int
lengthNonRecursive xs = let f x = 1
                        in foldr (+) 0 (map f xs)

{-
Exercise 3.8 Define a function that:
-}
-- doubles each number in a list.
doubleEach = map (*2)
-- pairs each element in a list with that number and one plus that number.
pairAndOne = let f x = (x, x + 1)
             in map f
-- adds together each pair of numbers in a list.
addEachPair = let f (x, y) = x + y
              in map f
-- adds "pointwise" the elements of a list of pairs.
addPairsPointwise :: [(Int, Int)] -> (Int, Int)
addPairsPointwise = let f (a, b) (c, d) = (a + c, b + d)
                    in foldr f (0, 0)

{-
Exercise 3.9 efine a polymorphic function
fuse :: [Dur] -> [Dur -> Music a] -> [Music a]
that combines a list of durations with a list of notes
lacking a duration, to create a list of complete notes.
-}
fuse :: [Dur] -> [Dur -> Music a] -> [Music a]
fuse (d:ds) (n:ns) = n d : (fuse ds ns)
fuse [] [] = []
fuse [] (f:fs) = error "Unequal lengths -- note array is longer."
fuse (d:ds) [] = error "Unequal lengths -- duration array is longer."
zippedMelody = line (fuse [qn, hn, sn] [c 4, d 4, e 4])

{-
Exercise 3.10 Define a function maxAbsPitch that determines the maximum absolute
pitch of a list of absolute pitches. Define minAbsPitch analogously.
Both functions should return an error if applied to the empty list.
-}

-- non-recursive
maxAbsPitch :: [AbsPitch] -> AbsPitch
maxAbsPitch = foldr1 max

-- recursive
maxAbsPitchR :: [AbsPitch] -> AbsPitch
maxAbsPitchR [] = error "Empty array for maxAbsPitchR!"
maxAbsPitchR [ap] = ap
maxAbsPitchR (ap:aps) = if ap > maxAbsPitchR aps then ap else maxAbsPitchR aps

{-
Exercise 3.11 Define a function chrom :: Pitch -> Pitch -> Music Pitch such that
chrom p1 p2 is a chromatic scale of quarter-notes whose first pitch
is p1 and last pitch is p2. If p1 > p2, the scale should be descending,
otherwise it should be ascending. If p1 == p2, then the scale should
contain just one note. (A chromatic scale is one whose successive
pitches are separated by one absolute pitch (i.e. one semitone)).
-}

-- recursive
chromR :: Pitch -> Pitch -> Music Pitch
chromR p1 p2 = if absPitch p1 == absPitch p2
               then note qn p1
               else note qn p1 :+:
               if absPitch p1 < absPitch p2
               then chromR (trans 1 p1) p2
               else chromR (trans (-1) p1) p2

{-
Exercise 3.12 Abstractly, a scale can be described by the intervals
between successive notes. For example, the 7-note major scale can be
defined as the sequence of 6 intervals [ 2, 2, 1, 2, 2, 2 ], and the
12-note chromatic scale by the 11 intervals [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1].
Define a function mkScale :: Pitch -> [Int] -> Music Pitch such that
mkScale p ints is the scale beginning at pitch p and having the intervallic
structure ints.
-}
mkScale :: Pitch -> [Int] -> Music Pitch
mkScale p [] = note qn p
mkScale p (i:is) = note qn p :+: mkScale (trans i p) is

{-
Exercise 3.13 Define an enumerated data type that captures each of the
standard major scale modes: Ionian, Dorian, Phrygian, Lydian, Mixolydian,
Aeolian, and Locrian. Then define a function genScale that, given one of
these contructors, generates a scale in the intervalic form described in
Exercise 3.12.
-}
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

{-
Exercise 3.14 Write the melody of “Frère Jacques” (or, “Are You Sleeping”)
in Euterpea. Try to make it as succinct as possible. Then, using
functions already defined, generate a traditional four-part round,
i.e. four identical voices, each delayed successively by two measures.
Use a different instrument to realize each voice.
-}
-- a helper function to double a line
double :: Music Pitch -> Music Pitch
double m = m :+: m
-- actual line
frereJacques :: Music Pitch
frereJacques = double (line [c 4 qn, d 4 qn, e 4 qn, c 4 qn])
                 :+: double (line [e 4 qn, f 4 qn, g 4 qn, rest qn])
                 :+: double (line [g 4 den, a 4 sn, g 4 en, f 4 en, e 4 qn, c 4 qn])
                 :+: double (line [c 4 qn, g 3 qn, c 4 qn, rest qn])
frereJacquesVoice2 = instrument Vibraphone (rest bn :+: frereJacques)
frereJacquesVoice3 = instrument Flute (rest bn :+: frereJacquesVoice2)
frereJacquesVoice4 = instrument OrchestralHarp (rest bn :+: frereJacquesVoice3)
frereJacquesChoir = frereJacques
                    :=: frereJacquesVoice2
                    :=: frereJacquesVoice3
                    :=: frereJacquesVoice4

{-
Exercise 3.15 Freddie the Frog wants to communicate privately with his
girlfriend Francine by encrypting messages sent to her. Frog brains are
not that large, so they agree on this simple strategy: each character
in the text shall be converted to the character “one greater” than it,
based on the representation described below (with wrap-around from 255 to 0).
Define functions encrypt and decrypt that will allow Freddie and Francine
to communicate using this strategy.
-}
encrypt :: String -> String
encrypt "" = ""
encrypt (c:cs) = toEnum (fromEnum c + 1) : encrypt cs
decrypt :: String -> String
decrypt "" = ""
decrypt (c:cs) = toEnum (fromEnum c - 1) : decrypt cs

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
    print "Length of [1, 2, 3, 4, 5, 6] is:"
    print (lengthNonRecursive [1, 2, 3, 4, 5, 6])
    print "doubleEach [1, 2, 3] is:"
    print (doubleEach [1, 2, 3])
    print "pairAndOne [1, 2, 3] is:"
    print (pairAndOne [1, 2, 3])
    print "addEachPair [(1, 2), (3, 4), (5, 6)] is:"
    print (addEachPair [(1, 2), (3, 4), (5, 6)])
    print "addPairsPointwise [(1, 2), (3, 4), (5, 6)] is:"
    print (addPairsPointwise [(1, 2), (3, 4), (5, 6)])
    print "Playing Exercise 3.9 ..."
    play zippedMelody
    print "Max of [3, 13, 2, 127, 17] is:"
    print (maxAbsPitch [3, 13, 2, 127, 17])
    print "[Recursive] Max of [27, 3, 211, 1, 33, 122] is:"
    print (maxAbsPitch [27, 3, 211, 1, 33, 122])
    print "[Recursive] Playing a chromatic line of quarter notes from C4 down to G3 ..."
    play (chromR (C, 4) (G, 3))
    print "Playing C major by mkScale ..."
    play (mkScale (C, 4) [2,2,1,2,2,2])
    print "Playing D dorian by mkScale and genScale ..."
    play (mkScale (C, 4) (genScale MDorian))
    print "Playing Frere Jacques choir ..."
    play frereJacquesChoir
    let message = "Hello, Francine!"
    let encrypted = encrypt message
    let decrypted = decrypt encrypted
    print ("Message is: " ++ message)
    print ("Encrypted message: " ++ encrypted)
    print ("Decrypted message: " ++ decrypted)