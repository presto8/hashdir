{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (foldM)
import System.Directory (doesDirectoryExist, listDirectory) -- from "directory"
import System.FilePath ((</>), FilePath) -- from "filepath"
import Control.Monad.Extra (partitionM) -- from the "extra" package

import qualified Data.ByteString
import qualified Crypto.Hash.SHA256 as SHA256


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

main :: IO ()
-- main = putStrLn "Hello, Haskell!"
main = do
    traverseDir (\_ -> True) (\() path -> print path) () "../test_dir"
    print_sha
    print_sha2
