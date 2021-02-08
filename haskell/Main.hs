{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (forM_, when)
import Crypto.Hash.SHA256 (hashlazy)
import qualified Crypto.Hash.SHA256 as SHA256
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T
import Text.Printf (printf)
import System.Directory.PathWalk
import System.Environment

print_sha = print digest
  where
    digest = SHA256.finalize ctx
    ctx    = foldl SHA256.update ctx0 (map B.pack [ [1, 2, 3] ] )
    ctx0   = SHA256.init

print_sha2 = print $ SHA256.hash "hello"

-- https://stackoverflow.com/questions/9502777/sha1-encoding-in-haskell
hashFile :: FilePath -> IO B.ByteString
hashFile = fmap hashlazy . BL.readFile

toHex :: B.ByteString -> String
toHex bytes = B.unpack bytes >>= printf "%02x"

-- https://hackage.haskell.org/package/pathwalk-0.3.1.2/docs/System-Directory-PathWalk.html
hash_path path = pathWalk path $ \dir subdirs files -> do
  forM_ files $ \file -> do
    let fullpath = dir ++ "/" ++ file
    let fullpath' = T.unpack $ T.replace (T.pack path) "" (T.pack fullpath)
    fullhash <- hashFile fullpath
    putStrLn $ (take 8 $ toHex fullhash) ++ "  ." ++ fullpath

main :: IO ()
main = do
    args <- getArgs
    hash_path $ head args
