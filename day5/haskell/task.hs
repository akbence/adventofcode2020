import System.IO
import Debug.Trace
import Data.List

trimnl = reverse . dropWhile (=='\n') . reverse
takeLastN n = reverse . take n . reverse

decodeBinary :: Char-> Char -> String -> Integer
decodeBinary tvalue fvalue input = (decodeBinaryRec tvalue fvalue (reverse input) 0 0)

decodeBinaryRec :: Char-> Char -> String -> Integer -> Integer -> Integer
decodeBinaryRec tvalue fvalue "" power result = result
decodeBinaryRec tvalue fvalue (x:xs) power result
  | x == tvalue = decodeBinaryRec tvalue fvalue xs (power+1) (result + 2 ^ power)
  | x == fvalue = decodeBinaryRec tvalue fvalue xs (power+1) result
  | otherwise = 5


decodeRow :: String -> Integer
decodeRow line = decodeBinary 'B' 'F' line

decodeColumn :: String -> Integer
decodeColumn line = decodeBinary 'R' 'L' line


decodeLine :: String -> Integer
decodeLine a = do
  let row = decodeRow (take 7 a)
  let column = decodeColumn (takeLastN 3 a)
  row * 8 + column

task2 :: [Integer] -> Integer
task2 [] = 0
task2 (a:b:xs) = task2helper a b xs

task2helper :: Integer -> Integer -> [Integer] -> Integer
task2helper a b [] = 0
task2helper a b xs
  | a + 2 == b = a + 1
  | otherwise = task2 ([b] ++ xs)

main = do
  content <- readFile "../input.txt"
  let linesOfFiles = lines content
  let lines = (sort (map (decodeLine . trimnl) linesOfFiles))
  putStrLn ("Task1 solution: " ++ (show (maximum lines)))
  putStrLn ("Task2 solution: " ++ (show (task2 lines)))
