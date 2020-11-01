module Main where

import Euterpea

t251 :: Music Pitch
t251 = let dMinor = d 4 wn :=: f 4 wn :=: a 4 wn
           gMajor = g 4 wn :=: b 4 wn :=: d 5 wn
           cMajor = c 4 bn :=: e 4 bn :=: g 4 bn
        in dMinor :+: gMajor :+: cMajor
{-
Exercise 2.1 The above example is fairly concrete, in that, for one, it is
rooted in C major, and furthermore it has a fixed tempo. Define a function
twoFiveOne :: Pitch -> Dur -> Music Pitch such that twoFiveOne p d
constructs a ii-V-I chord progression in the key whose major scale
begins on the pitch p (i.e., the first degree of the major scale
on which the progression is being constructed), where the  duration of
each of the first two chords is d, and the duration of the last chord
is 2 * d. To verify your code, prove by calculation that
twoFiveOne (C,4) wn = t251.
-}
twoFiveOne :: Pitch -> Dur -> Music Pitch
twoFiveOne p d = let root = note d p
                     doubleDurRoot = note (2 * d) p
                     oneMajor = doubleDurRoot :=: transpose 4 doubleDurRoot :=: transpose 7 doubleDurRoot
                     twoMinor = transpose 2 root :=: transpose 5 root :=: transpose 9 root
                     fiveMajor = transpose 7 root :=: transpose 11 root :=: transpose 14 root
                 in twoMinor :+: fiveMajor :+: oneMajor

cTwoFiveOne :: Music Pitch
cTwoFiveOne = twoFiveOne (C, 4) wn

{-
Exercise 2.2 Define a new algebraic data type called BluesPitchClass
that captures this scale (for example, you may wish to use the constructor
names _Ro, MT, Fo, Fi,_ and _MS_). Define a type synonym BluesPitch,
akin to Pitch. Define auxiliary functions ro, mt, fo, fi and ms, akin to
those in Figure 2.2, that make it easy to construct notes of type Music BluesPitch.
In order to play a value of type Music BluesPitch using MIDI, it will have to be
converted into a Music Pitch value. Define a function
fromBlues :: Music BluesPitch -> Music Pitch to do this,
using the “approximate” translation described at the beginning of this exercise.
-}
data BluesPitchClass = Ro | MT | Fo | Fi | MS
type BluesPitch = (BluesPitchClass, Octave)
ro, mt, fo, fi, ms :: Octave -> Dur -> Music BluesPitch
ro o d = note d (Ro, o)
mt o d = note d (MT, o)
fo o d = note d (Fo, o)
fi o d = note d (Fi, o)
ms o d = note d (MS, o)
fromBlues :: Music BluesPitch -> Music Pitch
fromBlues (Prim (Note d (Ro, o))) = note d (C, o)
fromBlues (Prim (Note d (MT, o))) = note d (Ef, o)
fromBlues (Prim (Note d (Fo, o))) = note d (F, o)
fromBlues (Prim (Note d (Fi, o))) = note d (G, o)
fromBlues (Prim (Note d (MS, o))) = note d (Bf, o)
fromBlues (Prim (Rest d)) = Prim (Rest d)
fromBlues (m1 :+: m2) = fromBlues m1 :+: fromBlues m2
fromBlues (m1 :=: m2) = fromBlues m1 :=: fromBlues m2
fromBlues (Modify control m) = Modify control (fromBlues m)

bluesMelody1 :: Music BluesPitch
bluesMelody1 = ro 4 en :+: ro 5 en :+: ms 4 en :+: fi 4 en :+: fo 4 en :+: mt 4 en :+: ro 4 en :+: mt 4 en :+: ro 4 qn
melody1 :: Music Pitch
melody1 = fromBlues bluesMelody1
bluesMelody2 :: Music BluesPitch
bluesMelody2 = fi 4 en :+: fo 4 en :+: mt 4 en :+: ms 4 en :+: ro 5 en :+: fi 4 en :+: fo 4 en :+: ms 4 en :+: ro 5 qn
melody2 :: Music Pitch
melody2 = fromBlues bluesMelody2
harmonizedMelody :: Music Pitch
harmonizedMelody = melody1 :=: melody2

transM :: AbsPitch -> Music Pitch -> Music Pitch
transM ap (Prim (Note d p)) = Prim (Note d (pitch (absPitch p + ap)))
transM ap (Prim (Rest d)) = Prim (Rest d)
transM ap (m1 :+: m2) = transM ap m1 :+: transM ap m2
transM ap (m1 :=: m2) = transM ap m1 :=: transM ap m2
transM ap (Modify control m) = Modify control (transM ap m)

dissonantMelody :: Music Pitch
dissonantMelody = transM (-1) melody1 :=: transM 7 melody2

main = do
    print "-------------------------------------------------------------------"
    print "Exercise 2.1"
    print "Playing t251 ..."
    play t251
    print "Playing twoFiveOne (C, 4) wn ..."
    play cTwoFiveOne
    print "-------------------------------------------------------------------"
    print "Exercise 2.2."
    print "Playing the first blues melody ..."
    play melody1
    print "Playing the second blues melody ..."
    play melody2
    print "Playing two blues melodies together (harmonized) ..."
    play harmonizedMelody
    print "-------------------------------------------------------------------"
    print "Exercise 2.5."
    print "Playing a dissonant harmony constructed with the help of transM ..."
    play dissonantMelody
    print "-------------------------------------------------------------------"