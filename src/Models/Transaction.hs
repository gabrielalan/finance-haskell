module Models.Transaction where

import Data.Aeson (ToJSON(..), FromJSON(..))
import GHC.Generics

data Transaction = Transaction {
    tId :: Int,
    tValue :: Int
  }
  deriving (Show, Generic)

instance ToJSON Transaction
instance FromJSON Transaction