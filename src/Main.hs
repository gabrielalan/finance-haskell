module Main where

import Models.Transaction
import System.Environment (lookupEnv)
import Data.String (fromString)
import Data.Text.Lazy (Text)
import Data.Monoid
import Web.Scotty
import Web.Scotty.Trans (ActionT)
import Greeting

data Except = Forbidden | ServerError | NotFound String
  deriving (Show, Eq)

-- instance Error Except where
--   noMsg = ServerError "Something went wrong processing this request"
--   strMsg str = NotFound str

-- instance ScottyError Except where
--   stringError = StringEx
--   showError = fromString . show

-- handleEx :: Text -> ActionM ()
-- handleEx Forbidden = do
--     status status403
--     html "<h1>Forbidden :(</h1>"
-- handleEx (NotFound error) = do
--     status status404
--     html $ error

getEnv :: Read a => a -> [Char] -> IO a
getEnv defValue name = fmap
  (maybe defValue read)
  (lookupEnv name)

transactionList :: [Transaction]
transactionList = [
  Transaction { tId = 1, tValue = 100 },
  Transaction { tId = 2, tValue = 200 }
  ]

matchId :: Int -> Transaction -> Bool
matchId id trans = tId trans == id

getFirstTransaction :: [Transaction] -> Maybe Transaction
getFirstTransaction [] = Nothing
getFirstTransaction (first : _) = Just first

getTransaction :: ActionM ()
getTransaction = do
  id <- param "id"
  json $ head $ filter (matchId id) transactionList

hello :: ActionM ()
hello = do
  name <- param "name"
  lang <- param "language"
  html $ mconcat [ "<h1>", greet name $ read lang, "</h1>" ]

routes :: ScottyM ()
routes = do
  -- defaultHandler handleEx

  get "/transactions/:id" getTransaction

  get "/:language/:name" hello

  get "/transactions" $ do
    json transactionList

  notFound $ html "Not found"

main :: IO ()
main = do 
  port <- (getEnv 3000 "FINANCE_SERVER_PORT")
  scotty port routes
