{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}

main :: IO ()
main = do
  array <- inputFromUser
  frame array 0 0
  return ()

inputFromUser :: IO [Int]
inputFromUser = do
   line <- getLine
   return $ map read (words line)

getAFrame :: (Eq a, Num a) => [a] -> [a]
getAFrame array = if head array /= 10 then slice 0 2 array else slice 0 1 array

computeNextRoundArrayTail :: (Eq t, Num t) => [Int] -> t -> [Int]
computeNextRoundArrayTail array timesToPop =
    if timesToPop == 0 || null array then array
    else computeNextRoundArrayTail popedOne (timesToPop - 1)
    where popedOne = removeFirst array


computeBonus :: (Eq t1, Num t1) => [Int] -> t1 -> Int -> Int
computeBonus [] timesToBonus bonus = bonus
computeBonus array timesToBonus bonus =
    if timesToBonus == 0 then bonus
    else computeBonus poppedArr (timesToBonus - 1) bonusCount
    where poppedArr = removeFirst array
          bonusCount = bonus + head array

frame :: (Eq t, Num t, Ord t) => [Int] -> Int -> t -> IO ()
frame array points gameFlag = do
    if gameFlag == 10 then putStr $ "TOTAL: " ++ show points
    else do
        let actualFrame = getAFrame array
        let nextRoundArray = computeNextRoundArrayTail array (length actualFrame)
        --STRIKE:
        if head actualFrame == 10 then do
            let bonusStrike = computeBonus nextRoundArray 2 0
            let printedFrame = printFrame actualFrame nextRoundArray 2 gameFlag (sum nextRoundArray)
            putStr printedFrame
            frame nextRoundArray (points + 10 + bonusStrike) (gameFlag + 1)
        --SPARE:
        else if sum actualFrame == 10 then do
            let bonusSpare = computeBonus nextRoundArray 1 0
            let printedFrame = printFrame actualFrame nextRoundArray 1 gameFlag (sum nextRoundArray)
            putStr printedFrame
            frame nextRoundArray (points + 10 + bonusSpare) (gameFlag + 1)
        --ANY PAIR:
        else do
            let pointsPair = sum actualFrame
            let printedFrame = printFrame actualFrame nextRoundArray 3 gameFlag (sum nextRoundArray)
            putStr printedFrame
            frame nextRoundArray (points + pointsPair) (gameFlag + 1)

slice :: Int -> Int -> [a] -> [a]
slice _ _ [] = []
slice _ _ [a] = []
slice from to xs = take (to - from) (drop from xs)

removeFirst :: [Int] -> [Int]
removeFirst [] = []
removeFirst [a] = []
removeFirst (x:xs) = xs

printFrame :: (Eq a1, Num a1, Num a2, Ord a2) =>[Int] -> [Int] -> a1 -> a2 ->  Int -> [Char]
printFrame actualFrame nextArray isSpareOrStrikeOrPair gameFlag sumOfBonus = do
    let headFrame =  show (head actualFrame)
    let headNextArray = show  (head nextArray)
    let secondNextArray =  show (nextArray!!1)

    --spare
    if isSpareOrStrikeOrPair == 1 then do
        --with 1 move left and at the end
        if length nextArray == 1 && gameFlag < 9 then headFrame ++ " / " ++ headNextArray ++ " | "
        else if length nextArray == 1 && gameFlag == 10 then  headFrame ++ " / " ++ headNextArray
        --at other frames
        else do
            if gameFlag < 9 then  headFrame ++ " / | "
            else   headFrame ++ " / " ++ headNextArray ++ " "
    --strike
    else if isSpareOrStrikeOrPair == 2 then do
        --at 10th frame
        if gameFlag == 9 && length nextArray > 1 then do
          if head nextArray == 10 && nextArray!!1 == 10 then "X X X "
          else if head nextArray == 10 && nextArray!!1 /= 10 then "X X " ++ secondNextArray ++ " "
          else if head nextArray /= 10 && nextArray!!1 == 10 then "X " ++ secondNextArray ++ " X "
          --spare after
          else if sumOfBonus == 10 then "X " ++ headNextArray ++ " / "
          else "X " ++ headNextArray ++ " " ++ secondNextArray
        --at other frames
        else if gameFlag < 9 then  "X_ | "
        else  "X "
    else do
    --other frames
        let secondFrame = show (actualFrame!!1)
        if gameFlag < 9 then  headFrame ++ " " ++ secondFrame ++ " | "
        else  headFrame ++ " " ++ secondFrame