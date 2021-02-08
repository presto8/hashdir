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
-- import System.Posix.Files

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
my_walk path = pathWalk path $ \dir subdirs files -> do
  forM_ files $ \file -> do
    let fullpath = dir ++ "/" ++ file
    let fullpath' = T.unpack $ T.replace (T.pack path) "" (T.pack fullpath)
    hashFile fullpath >>= putStr . take 8 . toHex
    putStrLn $ "  ." ++ fullpath'
    -- when (getSymbolicLinkStatus file . isSymbolicLink) $ do
      -- hashFile file >>= putStrLn . toHex

main :: IO ()
main = do
    -- print_sha
    -- print_sha2
    -- hashFile path >>= putStrLn . toHex
    let path = "../test_dir"
    my_walk path
