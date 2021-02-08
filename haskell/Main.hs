{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (foldM, forM_, when)
import System.Directory (doesDirectoryExist, listDirectory) -- from "directory"
import System.FilePath ((</>), FilePath) -- from "filepath"
import Control.Monad.Extra (partitionM) -- from the "extra" package

import qualified Data.ByteString
import qualified Crypto.Hash.SHA256 as SHA256

import Crypto.Hash.SHA256 (hashlazy)
import qualified Data.ByteString as Strict
import qualified Data.ByteString.Lazy as Lazy
import System.Process (system)
import Text.Printf (printf)

import System.Directory.PathWalk
import System.Posix.Files

-- https://stackoverflow.com/questions/51712083/recursively-search-directories-for-all-files-matching-name-criteria-in-haskell
traverseDir :: (FilePath -> Bool) -> (b -> FilePath -> IO b) -> b -> FilePath -> IO b
traverseDir validDir transition =
    let go state dirPath =
            do names <- listDirectory dirPath
               let paths = map (dirPath </>) names
               (dirPaths, filePaths) <- partitionM doesDirectoryExist paths
               state' <- foldM transition state filePaths -- process current dir
               foldM go state' (filter validDir dirPaths) -- process subdirs
     in go

-- http://hackage.haskell.org/package/cryptohash-sha256-0.11.102.0/docs/Crypto-Hash-SHA256.html

print_sha = print digest
  where
    digest = SHA256.finalize ctx
    ctx    = foldl SHA256.update ctx0 (map Data.ByteString.pack [ [1, 2, 3] ] )
    ctx0   = SHA256.init

print_sha2 = print $ SHA256.hash "hello"

-- https://stackoverflow.com/questions/9502777/sha1-encoding-in-haskell

hashFile :: FilePath -> IO Strict.ByteString
hashFile = fmap hashlazy . Lazy.readFile

toHex :: Strict.ByteString -> String
toHex bytes = Strict.unpack bytes >>= printf "%02x"

-- hashEntry :: FilePath -> String
-- hashEntry path = hashFile path >>= putStrLn . toHex

-- https://hackage.haskell.org/package/pathwalk-0.3.1.2/docs/System-Directory-PathWalk.html

my_walk path = pathWalk path $ \dir subdirs files -> do
  forM_ files $ \file -> do
    hashFile file >>= putStrLn . toHex

main :: IO ()
-- main = putStrLn "Hello, Haskell!"
main = do
    -- traverseDir (\_ -> True) (\() path -> print path) () "../test_dir"
    traverseDir (\_ -> True) (\() path -> hashFile path >>= putStrLn . toHex) () "../test_dir"
    -- traverseDir (\_ -> True) (\() path -> hashEntry path) () "../test_dir"
    print_sha
    print_sha2
    let path = "../test_dir/file1"
    hashFile path >>= putStrLn . toHex
    my_walk "."
