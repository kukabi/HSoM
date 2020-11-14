module Main where

import Euterpea
import Util
import ChickCorea
import JSBach
import PrefixExamples

main = do
    print "Playing Childrens's Songs no.6 by Chick Corea ..."
    play ChickCorea.childSong6
    print "Playing G Major Minuet by J. S. Bach ..."
    play JSBach.gMajorMinuet
    print "Playing a prefixed twelve tone series (Exercise 4.2) ..."
    play twelveTonePrefix
    print "Playing a minor melody with a different version of the prefix function (Exercise 4.3) ..."
    play minorPrefixVersion
