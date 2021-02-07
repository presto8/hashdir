module Main where

import Control.Monad (foldM)
import System.Directory (doesDirectoryExist, listDirectory) -- from "directory"
import System.FilePath ((</>), FilePath) -- from "filepath"
import Control.Monad.Extra (partitionM) -- from the "extra" package

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

main :: IO ()
-- main = putStrLn "Hello, Haskell!"
main = traverseDir (\_ -> True) (\() path -> print path) () "/tmp"
