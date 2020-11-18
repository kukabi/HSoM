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