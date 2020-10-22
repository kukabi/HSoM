### Chapter 02: Simple Music

**Exercise 2.1** The above example is fairly concrete, in that, for one, it is rooted in C major, and furthermore it has a fixed tempo. Define a function _twoFiveOne :: Pitch -> Dur -> Music Pitch_ such that _twoFiveOne p d_ constructs a ii-V-I chord progression in the key whose major scale begins on the pitch _p_ (i.e., the first degree of the major scale on which the progression is being constructed), where the duration of each of the first two chords is d, and the duration of the last chord is 2 \* _d_. To verify your code, prove by calculation that _twoFiveOne (C,4) wn = t251_.

Solution is in [app/Main.hs](./app/Main.hs). You can run it with `stack run` in this folder.

```haskell
twoFiveOne :: Pitch -> Dur -> Music Pitch
twoFiveOne p d = let root = note d p
                    doubleDurRoot = note (2 * d) p
                    -- I (double duration)
                    oneMajor = doubleDurRoot :=: transpose 4 doubleDurRoot :=: transpose 7 doubleDurRoot
                    -- ii
                    twoMinor = transpose 2 root :=: transpose 5 root :=: transpose 9 root
                    -- V
                    fiveMajor = transpose 7 root :=: transpose 11 root :=: transpose 14 root
                in twoMinor :+: fiveMajor :+: oneMajor
```

Proof:

```
twoFiveOne (C,4) wn = twoMinor :+: fiveMajor :+: oneMajor
=> (transpose 2 root :=: transpose 5 root :=: transpose 9 root)
:+: (transpose 7 root :=: transpose 11 root :=: transpose 14 root)
:+: (doubleDurRoot :=: transpose 4 doubleDurRoot :=: transpose 7 doubleDurRoot)
=> (transpose 2 (note wn (C,4)) :=: transpose 5 (note wn (C,4)) :=: transpose 9 (note wn (C,4)))
:+: (transpose 7 (note wn (C,4)) :=: transpose 11 (note wn (C,4)) :=: transpose 14 (note wn (C,4)))
:+: (note (2 * wn) (C,4) :=: transpose 4 (note (2 * wn) (C,4)) :=: transpose 7 (note (2 * wn) (C,4)))
=> (transpose 2 (Prim (Note wn (C,4))) :=: transpose 5 (Prim (Note wn (C,4))) :=: transpose 9 (Prim (Note wn (C,4))))
:+: (transpose 7 (Prim (Note wn (C,4))) :=: transpose 11 (Prim (Note wn (C,4))) :=: transpose 14 (Prim (Note wn (C,4))))
:+: (Prim (Note (2 * wn) (C,4)) :=: transpose 4 (Prim (Note (2 * wn) (C,4))) :=: transpose 7 (Prim (Note (2 * wn) (C,4))))
=> (Prim (Note wn (D,4)) :=: Prim (Note wn (F,4)) :=: Prim (Note wn (A,4)))
:+: (Prim (Note wn (G,4)) :=: Prim (Note wn (B,4)) :=: Prim (Note wn (D,5)))
:+: (Prim (Note (2 * wn) (C,4)) :=: Prim (Note (2 * wn) (E,4)) :=: Prim (Note (2 * wn) (G,4)))

t251 = dMinor :+: gMajor :+: cMajor
=> (d 4 wn :=: f 4 wn :=: a 4 wn)
:+: (g 4 wn :=: b 4 wn :=: d 5 wn)
:+: (c 4 bn :=: e 4 bn :=: g 4 bn)
=> (note wn (D,4) :=: note wn (F,4) :=: note wn (A,4)
:+: (note wn (G,4) :=: note wn (B,4) :=: note wn (D,5))
:+: (note bn (C,4) :=: note bn (E,4) :=: note bn (G,4))
=> (Prim (Note wn (D,4)) :=: Prim (Note wn (F,4)) :=: Prim (Note wn (A,4)))
:+: (Prim (Note wn (G,4)) :=: Prim (Note wn (B,4)) :=: Prim (Note wn (D,5)))
:+: (Prim (Note (2 * wn) (C,4)) :=: Prim (Note (2 * wn) (E,4)) :=: Prim (Note (2 * wn) (G,4)))
```

**Exercise 2.2** The _PitchClass_ data type implies the use of standard Western harmony, in particular the use of a twelve-tone equal temperament scale. But there are many other scale possibilities. For example, the pentatonic blues scale consists of five notes (thus “pentatonic”) and, in the key of C, approximately corresponds to the notes C, E♭, F, G, and B♭. More abstractly, let’s call these the root, minor third, fourth, fifth, and minor seventh, respectively. Your job is to:

1. Define a new algebraic data type called _BluesPitchClass_ that captures this scale (for example, you may wish to use the constructor names _Ro, MT, Fo, Fi,_ and _MS_).

    ```haskell
    data BluesPitchClass = Ro | MT | Fo | Fi | MS
    ```

2. Define a type synonym _BluesPitch_, akin to _Pitch_.

    ```haskell
    type BluesPitch = (BluesPitchClass, Octave)
    ```

3. Define auxiliary functions _ro, mt, fo, fi,_ and _ms_, akin to those in Figure 2.2, that make it easy to construct notes of type _Music BluesPitch_.

    ```haskell
    ro, mt, fo, fi, ms :: Octave -> Dur -> Music BluesPitch
    ro o d = note d (Ro, o)
    mt o d = note d (MT, o)
    fo o d = note d (Fo, o)
    fi o d = note d (Fi, o)
    ms o d = note d (MS, o)
    ```

4. In order to play a value of type Music BluesPitch using MIDI, it will have to be converted into a Music Pitch value. Define a function fromBlues :: Music BluesPitch → Music Pitch to do this, using the “approximate” translation described at the beginning of this exercise.

    ```haskell
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
    ```

5. Write out a few melodies of type _Music BluesPitch_, and play them using _fromBlues_ and _play_.

    Melodies are in [app/Main.hs](./app/Main.hs). You can run it with `stack run` in this folder.

**Exercise 2.3** Show that _abspitch (pitch ap) = ap_, and, up to enharmonic equivalences, _pitch (abspitch p) = p_.

```
abspitch (pitch ap)
=> abspitch ([C, Cs, D, Ds, ... , As, B]!!(ap mod 12), (ap div 12) - 1)
=> 12 * ((ap div 12) - 1 + 1) + pcToInt ([C, Cs, D, Ds, ... , As, B]!!(ap mod 12))
=> 12 * (ap div 12) + pcToInt ([C, Cs, D, Ds, ... , As, B]!!(ap mod 12))
=> 12 * (ap div 12) + (ap mod 12)
=> ap
```

**Exercise 2.4** Show that _trans i (trans j p) = trans (i + j ) p_.

_Hint: absPitch (pitch ap) = ap_

```
trans i (trans j p)
=> trans i (pitch (absPitch p + j))
=> pitch (absPitch (pitch (absPitch p + j)) + i)
=> pitch (absPitch p + j + i)

trans (i + j) p
=> pitch (absPitch p + i + j)
```

**Exercise 2.5** Transpose is part of the _Control_ data type, which in turn is part of the _Music_ data type. Its use in transposing a _Music_ value is thus a kind of “annotation” — it doesn’t really change the _Music_ value, it just annotates it as something that is transposed.

Define instead a recursive function _transM :: AbsPitch -> Music Pitch -> Music Pitch_ that actually changes each note in a _Music Pitch_ value by transposing it by the interval represented by the first argument.

Hint: To do this properly, you will have to pattern match against the _Music_ value, something like this:

_transM ap (Prim (Note d p)) = ..._\
_transM ap (Prim (Rest d)) = ..._\
_transM ap (m1 :+: m2) = ..._\
_transM ap (m1 :=: m2) = ..._\
_transM ap (Modify...) = ..._

```haskell
transM :: AbsPitch -> Music Pitch -> Music Pitch
transM ap (Prim (Note d p)) = Prim (Note d (pitch (absPitch p + ap)))
transM ap (Prim (Rest d)) = Prim (Rest d)
transM ap (m1 :+: m2) = transM ap m1 :+: transM ap m2
transM ap (m1 :=: m2) = transM ap m1 :=: transM ap m2
transM ap (Modify control m) = Modify control (transM ap m)
```
