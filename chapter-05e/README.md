### Chapter 05: Syntactic Magic

Solution, application and examples are in [Main.hs](./app/Main.hs).

**Exercise 5.1** Define a function _twice_ that, given a function _f_, returns a function that applies _f_ twice to its argument. For example:

_(twice (+1)) 2 => 4_

What is the principal type of _twice_? Describe what _twice twice_ does and give an example of its use. Also consider the functions _twice twice twice_ and _twice (twice twice)_.

```haskell
-- for f to be applied twice, the parameter type and
-- return type should be the same
twice :: (a -> a) -> a -> a
twice f a = f (f a)
```

_twice twice_ will apply the function to the parameter four times:

```
twice f a => f (f a)
twice twice f a => f (f (f (f a)))
```

**_twice twice twice_ applies the function sixteen times, yet I have not yet managed to understand why. Still working on it.**

**Exercise 5.2** Generalize _twice_ defined in the previous exercise by defining a function _power_ that takes a function _f_ and an integer _n_ and returns a functions that applies the function _f_ to its argument _n_ times. For example:

_power_ (+2) 5 1 => 11

Use _power_ in a musical context to define something useful.

```haskell
power :: (a -> a) -> Int -> a -> a
power f n a
    | n < 0     =  error "n cannot be less than 0."
    | n == 0    = a
    | otherwise = power f (n - 1) (f a)
```

We can use it to repeat a piece of music _n_ times:

```haskell
repeatN :: Int -> Music a -> Music a
repeatN 0 _ = rest 0
repeatN n m = power (:+: m) (n - 1) m
```

**Exercise 5.3** Suppose we define a function _fix_ as:

```haskell
fix f = f (fix f)
```

What is the principal type of _fix_?

-   _fix_ finds the fixed point of a function, where _f a = a_. Its type is _(a -> a) -> a_

Support further that we have a recursive function:

```haskell
remainder :: Integer -> Integer -> Integer
remainder a b = if a < b then a
                else remainder (a - b) b
```

Rewrite this function using _fix_ so that there is no recursive call to _remainder_. Do you think this process can be applied to _any_ recursive function?

```haskell
remainder' = fix (\f a b -> if a < b then a else f (a - b) b)
```

-   _Note: Something I don't understand here is that there actually is recursion in this definition._
-   Since the fixed point represent the base condition for a recursive call, yes, I think that _fix_ can be applied to any recursive function. An example:

    ```haskell
    sumNaturalNumbersUpTo :: Integer -> Integer
    sumNaturalNumbersUpTo 1 = 1
    sumNaturalNumbersUpTo n = n + sumNaturalNumbersUpTo (n - 1)
    sumNaturalNumbersUpTo' :: Integer -> Integer
    sumNaturalNumbersUpTo' = fix (\f a -> if a == 1 then a else a + f (a - 1))
    ```
