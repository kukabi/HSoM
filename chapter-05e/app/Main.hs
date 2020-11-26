module Main where

import Euterpea

-- for f to be applied twice, the parameter type and return type should be
-- the same
twice :: (a -> a) -> a -> a
twice f a = f (f a)

power :: (a -> a) -> Int -> a -> a
power f n a 
    | n < 0     =  error "n cannot be less than 0."
    | n == 0    = a
    | otherwise = power f (n - 1) (f a)

repeatN :: Int -> Music a -> Music a
repeatN 0 _ = rest 0
repeatN n m = power (:+: m) (n - 1) m

-- Exercise 5.3
fix :: (a -> a) -> a
fix f = f (fix f)
remainder :: Integer -> Integer -> Integer
remainder a b = if a < b then a else remainder (a - b) b
remainder' :: Integer -> Integer -> Integer
remainder' = fix (\f a b -> if a < b then a else f (a - b) b)

sumNaturalNumbersUpTo :: Integer -> Integer
sumNaturalNumbersUpTo 1 = 1
sumNaturalNumbersUpTo n = n + sumNaturalNumbersUpTo (n - 1)
sumNaturalNumbersUpTo' :: Integer -> Integer
sumNaturalNumbersUpTo' = fix (\f a -> if a == 1 then a else a + f (a - 1))

-- Exercise 5.4
apPairs :: [AbsPitch] -> [AbsPitch] -> [(AbsPitch,AbsPitch)]
apPairs aps1 aps2 = [
        (ap1, ap2) | 
            ap1 <- aps1, 
            ap2 <- aps2, 
            abs(ap1 - ap2) > 2,
            abs(ap1 - ap2) < 8
    ]

musicalAPPairs :: [(AbsPitch,AbsPitch)] -> Music Pitch
musicalAPPairs pairs = let dur ap = if (ap `mod` 3 == 0) then sn else qn
                           pairToChord (ap1, ap2) = 
                               chord [
                                   note (dur ap1) (pitch ap1),
                                   note (dur ap1) (pitch ap2)
                               ]
                       in line (map pairToChord pairs)
strangeWholeToneMusic = musicalAPPairs
                            (
                                apPairs
                                   [absPitch (C, 3), absPitch (D, 3)..absPitch (Gs, 4)]
                                   [absPitch (G, 3), absPitch (A, 3)..absPitch (Cs, 5)]
                            )
                            
main = do
    print "twice (+1) 2 is:"
    print $ twice (+1) 2
    print "twice twice (+1) 2 is:"
    print $ twice twice (+1) 2
    print "twice twice twice (+1) 2 is:"
    print $ twice twice twice (+1) 2
    print "power (+2) 5 1 is:"
    print $ power (+2) 5 1
    print "Repeating [f 4 sn, g 4 sn, c 4 sn] 7 times using a variation of the power function:"
    play $ repeatN 7 (line [f 4 sn, g 4 sn, c 4 sn])
    print "(remainder' 29 13) is:"
    print $ remainder' 29 13
    print "Sum of natural numbers up to 15 is:"
    print $ sumNaturalNumbersUpTo' 15
    print $ apPairs [1, 2, 3] [15, 16, 9, 2]
    print "Playing music from pairs ..."
    play strangeWholeToneMusic