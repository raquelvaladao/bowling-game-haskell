main :: IO ()
main = do
  array <- inputFromUser
  frame array 0 0
  return ()

inputFromUser :: IO [Int]
inputFromUser = map read . words <$> getLine

--actualFrame é o próx [10] ou par [a,b] até o array ser percorrido. 
--o bônus é  calculado sobre o array da próxima rodada e por isso gameFlag vai até 10 e não 12.
--o bônus é o sum take [x,y] de nextRoundArray se for um strike, e sum take [x] se for spare. Soma com 10.
--caso contrário não há bônus e a nova pontuação é a somada à soma do próprio par [a,b]
frame :: (Eq t, Num t, Ord t) => [Int] -> Int -> t -> IO ()
frame array points 10 = putStr $ "| " ++ show points
frame array points gameFlag = do
        let actualFrame = if head array /= 10 then take 2 array else take 1 array
        let nextRoundArray = drop (length actualFrame) array 
        if head actualFrame == 10 then do
            putStr (printFrame actualFrame nextRoundArray 2 gameFlag (sum nextRoundArray))
            frame nextRoundArray (points + 10 + sum (take 2 nextRoundArray)) (gameFlag + 1)
        else if sum actualFrame == 10 then do
            putStr (printFrame actualFrame nextRoundArray 1 gameFlag (sum nextRoundArray))
            frame nextRoundArray (points + 10 + sum (take 1 nextRoundArray)) (gameFlag + 1)
        else do
            putStr (printFrame actualFrame nextRoundArray 3 gameFlag (sum nextRoundArray))
            frame nextRoundArray (points + sum actualFrame) (gameFlag + 1)
        
printFrame :: (Eq a1, Num a1, Num a2, Ord a2) =>[Int] -> [Int] -> a1 -> a2 ->  Int -> [Char]
printFrame actualFrame nextArray isSpareOrStrikeOrPair gameFlag sumOfBonus = do
    let headNextArray = show (head nextArray)
    let headActualFrame = show (head actualFrame)
    --spare
    if isSpareOrStrikeOrPair == 1 then do
        if length nextArray == 1 && gameFlag < 9 then headActualFrame ++ " / " ++ headNextArray ++ " | "
        else if length nextArray == 1 && gameFlag == 10 then headActualFrame ++ " / " ++ headNextArray
        else do
            if gameFlag < 9 then headActualFrame ++ " / | " else headActualFrame ++ " / " ++ headNextArray ++ " "
    --strike
    else if isSpareOrStrikeOrPair == 2 then do
        if gameFlag == 9 && length nextArray > 1 then do
          if head nextArray == 10 then do 
            if nextArray!!1 == 10 then "X X X " else "X X " ++ show (nextArray!!1) ++ " "
          else if head nextArray /= 10 && nextArray!!1 == 10 then "X " ++ show (nextArray!!1) ++ " X "
          else if sumOfBonus == 10 then "X " ++ headNextArray ++ " / "
          else "X " ++ headNextArray ++ " " ++ show (nextArray!!1)
        else  "X _ | "
    else do
        if gameFlag < 9 then  headActualFrame ++ " " ++ show (actualFrame!!1) ++ " | "
        else show (head actualFrame) ++ " " ++ show (actualFrame!!1) ++ " "
