module Main where

import Control.Exception
import Models.Transaction
import System.Environment (lookupEnv)
import Data.String (fromString)
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as TL
import Data.Monoid
import Web.Scotty
import qualified Web.Scotty.Trans as ST
import Data.Typeable
import Network.HTTP.Types.Status
import Greeting

data Except = Forbidden | ServerError | NotFound Text
  deriving (Show, Eq, Typeable)

instance ST.ScottyError Except where
  stringError = NotFound . TL.pack
  showError ServerError = "Something went wrong processing this request"
  showError (NotFound t) = t

getEnv :: Read a => a -> [Char] -> IO a
getEnv defValue name = fmap
  (maybe defValue read)
  (lookupEnv name)

getOr404 :: Maybe a -> ActionM a
getOr404 v = maybe (raise "Transaction") return v

transactionList :: [Transaction]
transactionList = [
  Transaction { tId = 1, tValue = 100 },
  Transaction { tId = 2, tValue = 200 }
  ]

matchId :: Int -> Transaction -> Bool
matchId id trans = tId trans == id

-- getFirstTransaction :: [Transaction] -> Maybe Transaction
getFirstTransaction [] = Nothing
getFirstTransaction (first : _) = Just first

getTransaction :: ActionM ()
getTransaction = do
  id <- param "id"
  record <- getOr404 $ getFirstTransaction $ filter (matchId id) transactionList
  json record

hello :: ActionM ()
hello = do
  name <- param "name"
  lang <- param "language"
  html $ mconcat [ "<h1>", greet name $ read lang, "</h1>" ]

-- handleEx ServerError = ST.status status500
-- handleEx (NotFound problem) = do
--   ST.status status404
--   html $ problem
handleEx :: Text -> ActionM ()
handleEx reason = ST.status status404 >> text ("Not found: " <> reason)

routes :: ScottyM ()
routes = do
  defaultHandler handleEx

  get "/transactions/:id" getTransaction

  get "/:language/:name" hello

  get "/transactions" $ do
    json transactionList

  notFound $ html "Not found"

main :: IO ()
main = do 
  port <- (getEnv 3000 "FINANCE_SERVER_PORT")
  scotty port routes
