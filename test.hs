class Measurable a where
  distance :: a -> a -> Double

data Point2 = Point2 Double Double
data Point3 = Point3 Double Double Double

distance2 :: Point2 -> Point2 -> Double
distance2 (Point2 x1 y1) (Point2 x2 y2) =
  sqrt (dx * dx + dy * dy)
  where dx = x1 - x2
        dy = y1 - y2

instance Measurable Point2 where
  distance = distance2

instance Measurable Point3 where
  distance (Point3 x1 y1 z1) (Point3 x2 y2 z2) =
    sqrt (dx * dx + dy * dy + dz * dz)
    where dx = x1 - x2
          dy = y1 - y2
          dz = z1 - z2

instance Measurable Double where
  distance x y = abs (x - y)

pathLength :: Measurable a => [a] -> Double
pathLength [] = 0
pathLength (_ : []) = 0
pathLength (p0 : p1 : ps) = distance p0 p1 + pathLength (p1 : ps)

data Test a = Test a
  deriving Eq

data MaybeTest a = NoTest | HasTest a

instance (Show a) => Show (Test a) where
  show (Test v) = "Test " ++ show v

instance (Eq a) => Eq (MaybeTest a) where
  NoTest == NoTest = True
  NoTest == (HasTest _) = False
  (HasTest _) == NoTest = False
  (HasTest v1) == (HasTest v2) = v1 == v2

fromMaybe :: a -> MaybeTest a -> a
fromMaybe defaultval NoTest = defaultval
fromMaybe _ (HasTest x) = x

greet = do
  putStrLn "Who are you?"
  who <- getLine
  putStrLn ("Hello " ++ who)

greetForever = do
  greet
  greetForever

encrypt :: Char -> Char
encrypt c
  | 'A' <= c && c < 'Z' = toEnum (fromEnum 'A' + 1)
  | c == 'Z' = 'A'
  | otherwise = c

main = interact (map encrypt)
