module Main where

import System.Environment (lookupEnv)
import Web.Scotty
import Data.Monoid (mconcat)
import Greeting

getEnv :: Read a => a -> [Char] -> IO a
getEnv defValue name = fmap
  (maybe defValue read)
  (lookupEnv name)

main :: IO ()
main = do 
  port <- (getEnv 3000 "FINANCE_SERVER_PORT")
  scotty port $ do
    get "/:language/:name" $ do
      name <- param "name"
      lang <- param "language"
      let language = read lang
      html $ mconcat [ "<h1>", greet name language, "</h1>" ]
