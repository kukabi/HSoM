### Chapter 06: More Music

**Exercise 6.1** Show that _retro ◦ retro_, _invert ◦ invert_ and _retroInvert ◦ invertRetro_ are the identities on values created by _line_. (You may use lemma that _reverse(reverse l) == l_.)

We can also add the lemma that _line (lineToList m) == m_, and it follows that:

```
retro => line ◦ reverse ◦ lineToList
retro ◦ retro => line ◦ reverse ◦ lineToList ◦ line ◦ reverse ◦ lineToList

line ◦ reverse ◦ lineToList ◦ line ◦ reverse ◦ lineToList m
=> line ◦ reverse ◦ reverse ◦ lineToList m
=> line ◦ lineToList m
=> m
```

_p_ is the pitch to be inverted and _r_ is the root against which the inversion is made:

```
invert (p, r) => pitch (2 * absPitch r - absPitch p)
invert ◦ invert (p, r)
=> pitch (2 * absPitch r - absPitch (pitch (2 * absPitch r - absPitch p)))
=> pitch (2 * absPitch r - 2 * absPitch r + absPitch p)
=> pitch (absPitch p)
=> p
```

Using the previous two lemmas:

```
retroInvert ◦ invertRetro
=> retro ◦ invert ◦ invert ◦ retro m
=> retro ◦ retro m
=> m
```
