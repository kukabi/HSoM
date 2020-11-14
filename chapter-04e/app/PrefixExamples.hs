module PrefixExamples where

import Euterpea
import Util

twelveTonePCs = [c, a, fs, bf, cs, gf, af, d, f, b, ef, g]
twelveToneDurs = [en, en, en, en, en, qn]
twelveTone = [
                 (twelveTonePCs!!0) 5 (twelveToneDurs!!0),
                 (twelveTonePCs!!1) 3 (twelveToneDurs!!1),
                 (twelveTonePCs!!2) 4 (twelveToneDurs!!2),
                 (twelveTonePCs!!3) 4 (twelveToneDurs!!3),
                 (twelveTonePCs!!4) 2 (twelveToneDurs!!4),
                 (twelveTonePCs!!5) 5 (twelveToneDurs!!5),
                 (twelveTonePCs!!6) 6 (twelveToneDurs!!0),
                 (twelveTonePCs!!7) 2 (twelveToneDurs!!1),
                 (twelveTonePCs!!8) 4 (twelveToneDurs!!2),
                 (twelveTonePCs!!9) 4 (twelveToneDurs!!3),
                 (twelveTonePCs!!10) 3 (twelveToneDurs!!4),
                 (twelveTonePCs!!11) 3 (twelveToneDurs!!5),
                 (twelveTonePCs!!0) 3 (twelveToneDurs!!0),
                 (twelveTonePCs!!1) 2 (twelveToneDurs!!1),
                 (twelveTonePCs!!2) 2 (twelveToneDurs!!2),
                 (twelveTonePCs!!3) 1 (twelveToneDurs!!3),
                 (twelveTonePCs!!4) 4 (twelveToneDurs!!4),
                 (twelveTonePCs!!5) 7 (twelveToneDurs!!5),
                 (twelveTonePCs!!6) 3 (twelveToneDurs!!0),
                 (twelveTonePCs!!7) 5 (twelveToneDurs!!1)
             ]
twelveTonePrefix :: Music Pitch
twelveTonePrefix = tempo 1.2 (instrument AcousticGrandPiano (line (concat (prefixes twelveTone))))

minorMelody = [a 4 qn, c 5 qn, b 2 qn, e 5 qn, rest qn, g 4 qn, f 4 qn, rest qn, e 4 qn, f 2 qn, g 4 qn, a 4 hn]

-- a different version of prefix
prefixVersion :: [Music a] -> Music a
prefixVersion mel = let m1 = line (concat (prefixes mel))
                        m2 = transpose 7 (line (concat (prefixes mel)))
                        m3 = transpose 12 (line (concat (prefixes mel)))
                        m = m1 :=: m2 :=: m3
                    in tempo 4 m :+: tempo 4 (transpose (-5) m) :+: tempo 4 m
minorPrefixVersion = prefixVersion minorMelody