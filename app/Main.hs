{-
Acknowledgement:
Used claude (AI) for reference on the monad API 
e.g. M.fromListWith and conceptual clarity on monads
-}
module Main where

import Data.Array (Array, array, (!))
import Data.List (maximumBy)
import qualified Data.Map.Strict as M
import Data.Ord (comparing)
import Text.Printf (printf)

-- Part 1: The Probability Type

newtype Probability a
  = Probability { getProbabilities :: [(a, Double)] }
    deriving Show

instance Functor Probability where
  fmap f (Probability ps) = Probability [(f a, p) | (a, p) <- ps]

instance Applicative Probability where
  pure x = Probability [(x, 1)]
  Probability fs <*> Probability xs =
    Probability [(f x, pf * px) | (f, pf) <- fs, (x, px) <- xs]

instance Monad Probability where
  Probability ps >>= f =
    Probability [(y, p * q) | (x, p) <- ps, (y, q) <- getProbabilities (f x)]

roll :: Probability Int
roll = Probability [(i, 1 / 6) | i <- [1 .. 6]]

-- Part 2: Normalize

normalize :: (Ord a) => Probability a -> Probability a
normalize (Probability ps) =
  Probability . M.toAscList . M.fromListWith (+) $ ps

-- Part 3: Efficient rollDice

rollDice :: Int -> Probability Int
rollDice 0 = pure 0
rollDice n = normalize $ do
  prev <- rollDice (n - 1)
  r <- roll
  pure (prev + r)

mode :: Probability Int -> Int
mode (Probability ps) = fst $ maximumBy (comparing snd) ps

-- Part 4: Rolling Stones

rollingStones :: Array Int (Probability Int)
rollingStones = arr
  where
    arr = array (0, 50) [(n, go n) | n <- [0 .. 50]]
    go 0 = pure 0
    go n = normalize $ do
      r <- roll
      rest <- arr ! max 0 (n - r)
      pure (rest + 1)

firstPlayerWinProb :: Int -> Double
firstPlayerWinProb n =
  sum [p | (k, p) <- getProbabilities (rollingStones ! n), odd k]

main :: IO ()
main = do
  putStrLn "Part 3: Mode of rollDice 100"
  let rd100 = rollDice 100
  putStrLn $ "  mode = " ++ show (mode rd100)
  putStrLn ""

  putStrLn "Part 4: Rolling Stones"
  mapM_ (\n -> printf "  %d: %.2f%%\n" n (100 * firstPlayerWinProb n :: Double))
    [2 .. 50]
