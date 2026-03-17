{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_probability (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
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

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/k3sc0re/.cabal/bin"
libdir     = "/Users/k3sc0re/.cabal/lib/aarch64-osx-ghc-9.6.7/probability-0.1.0.0-inplace-probability"
dynlibdir  = "/Users/k3sc0re/.cabal/lib/aarch64-osx-ghc-9.6.7"
datadir    = "/Users/k3sc0re/.cabal/share/aarch64-osx-ghc-9.6.7/probability-0.1.0.0"
libexecdir = "/Users/k3sc0re/.cabal/libexec/aarch64-osx-ghc-9.6.7/probability-0.1.0.0"
sysconfdir = "/Users/k3sc0re/.cabal/etc"

getBinDir     = catchIO (getEnv "probability_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "probability_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "probability_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "probability_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "probability_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "probability_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
