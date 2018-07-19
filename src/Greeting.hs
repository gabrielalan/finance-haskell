module Greeting where

import Data.Monoid (mconcat)
import Data.Text.Lazy (Text)

data Language = English | Portuguese
  deriving (Read)

greeting :: Language -> Text
greeting English = "Hello"
greeting Portuguese = "Olá"

greet :: Text -> Language -> Text
greet name language =
  mconcat [ greeting language, " ", name ]