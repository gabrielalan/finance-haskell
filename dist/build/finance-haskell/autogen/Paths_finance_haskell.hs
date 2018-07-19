{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_finance_haskell (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/gabrielalanpereira/Library/Haskell/bin"
libdir     = "/Users/gabrielalanpereira/Library/Haskell/ghc-8.2.2-x86_64/lib/finance-haskell-0.1.0.0"
dynlibdir  = "/Users/gabrielalanpereira/Library/Haskell/ghc-8.2.2-x86_64/lib/x86_64-osx-ghc-8.2.2"
datadir    = "/Users/gabrielalanpereira/Library/Haskell/share/ghc-8.2.2-x86_64/finance-haskell-0.1.0.0"
libexecdir = "/Users/gabrielalanpereira/Library/Haskell/libexec/x86_64-osx-ghc-8.2.2/finance-haskell-0.1.0.0"
sysconfdir = "/Users/gabrielalanpereira/Library/Haskell/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "finance_haskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "finance_haskell_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "finance_haskell_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "finance_haskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "finance_haskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "finance_haskell_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
