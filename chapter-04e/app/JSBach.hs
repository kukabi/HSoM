module JSBach (gMajorMinuet) where

import Euterpea
import Util

-- transcription of Bach Minuet in G Major BWV Anh.114

-- right hand part 1
-- rightHandM1to2 is short for right hand measures 1 to 2
rightHandM1to2 = d 5 qn :+: addDur en [g 4, a 4, b 4, c 5] :+: d 5 qn :+: g 4 en :+: rest en :+: g 4 qn
rightHandM3to4 = e 5 qn :+: mordent (-1) (c 5 en) :+: addDur en [d 5, e 5, fs 5]
                     :+: g 5 qn :+: g 4 en :+: rest en :+: g 4 qn
rightHandM5to6 = quickMordent (-1) (c 5 qn) :+: addDur en [d 5, c 5, b 4, a 4]
                     :+: b 4 qn :+: addDur en [c 5, b 4, a 4, g 4]
rightHandM7to8 = fs 4 qn :+: addDur en [g 4, a 4, b 4, g 4] :+: quickGraceNote 2 (a 4 dhn)
rightHandM15to16 = a 4 qn :+: addDur en [b 4, a 4, g 4, fs 4] :+: g 4 dhn
rightHandPt1 = line [
                       rightHandM1to2, rightHandM3to4, rightHandM5to6, rightHandM7to8,
                       rightHandM1to2, rightHandM3to4, rightHandM5to6, rightHandM15to16
                    ]

-- right hand part 2
rightHandM17to20 = b 5 qn :+: addDur en [g 5, a 5, b 5, g 5]
                       :+: a 5 qn :+: addDur en [d 5, e 5, fs 5, d 5]
                       :+: g 5 qn :+: addDur en [e 5, fs 5, g 5, d 5]
                       :+: cs 5 qn :+: b 4 en :+: cs 5 en :+: a 4 en :+: rest en
rightHandM21to24 = addDur en [a 4, b 4, cs 5, d 5, e 5, fs 5] :+: addDur qn [g 5, fs 5, e 5]
                       :+: addDur qn [fs 5, a 4, cs 5] :+: d 5 hn :+: rest qn
rightHandM25to28 = d 5 qn :+: addDur en [g 4, fs 4] :+: g 4 qn
                       :+: e 5 qn :+: addDur en [g 4, fs 4] :+: g 4 qn
                       :+: addDur qn [d 5, c 5, b 4] :+: addDur en [a 4, g 4, fs 4, g 4] :+: a 4 qn
rightHandM29to32 = addDur en [d 4, e 4, fs 4, g 4, a 4, b 4]
                       :+: c 5 qn :+: quickMordent 1 (b 4 qn) :+: a 4 qn
                       :+: addDur en [b 4, d 5] :+: g 4 qn :+: fs 4 qn
                       :+: chord [b 3 dhn, d 4 dhn, g 4 dhn]
rightHandPt2 = line [rightHandM17to20, rightHandM21to24, rightHandM25to28, rightHandM29to32]

-- right hand complete
rightHand = times 2 rightHandPt1 :+: times 2 rightHandPt2

-- left hand part 1
-- leftHandM1t4 is short for left hand measures 1 to 4
leftHandM1to4 = chord [g 3 hn, b 3 hn, d 4 hn] :+: a 3 qn
                   :+: b 3 dhn :+: c 4 dhn :+: b 3 dhn
leftHandM5to6 = a 3 dhn :+: g 3 dhn
leftHandM7to8 = addDur qn [d 4, b 3, g 3, d 4] :+: addDur en [d 3, c 4, b 3, a 3]
leftHandM9to10 = b 3 hn :+: a 3 qn :+: addDur qn [g 3, b 3, g 3]
leftHandM11to12 = c 4 dhn :+: b 3 qn :+: addDur en [c 4, b 3, a 3, g 3]
leftHandM13to16 = a 3 hn :+: fs 3 qn :+: g 3 hn :+: b 3 qn
                     :+: addDur qn [c 4, d 4, d 3] :+: g 3 hn :+: g 2 qn
leftHandPt1 = line [
                       leftHandM1to4, leftHandM5to6, leftHandM7to8, leftHandM9to10,
                       leftHandM11to12, leftHandM13to16
                   ]

-- left hand part 2
leftHandM17to20 = g 3 dhn :+: fs 3 dhn :+: addDur qn [e 3, g 3, e 3] :+: a 3 hn :+: a 2 qn
leftHandM21to24 = a 3 dhn
                      :+: addDur qn [b 3, d 4, cs 4]
                      :+: addDur qn [d 4, fs 3, a 3]
                      :+: addDur qn [d 4, d 3, c 4]
leftHandM25to28 = ((b 3 hn :+: b 3 qn) :=: (rest qn :+: d 4 hn))
                      :+: ((c 4 hn :+: c 4 qn) :=: (rest qn :+: e 4 hn))
                      :+: addDur qn [b 3, a 3, g 3]
                      :+: d 4 hn :+: rest qn
leftHandM29to32 = (d 3 dhn :=: (rest hn :+: fs 3 qn))
                      :+: addDur qn [e 3, g 3, fs 3, g 3, b 2, d 3, g 3, d 3, g 2]
leftHandPt2 = line [leftHandM17to20, leftHandM21to24, leftHandM25to28, leftHandM29to32]

-- left hand complete
leftHand = times 2 leftHandPt1 :+: times 2 leftHandPt2

gMajorMinuet = instrument AcousticGrandPiano (tempo 1 (leftHand :=: rightHand))