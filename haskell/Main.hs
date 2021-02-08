{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (forM_, when)
import qualified Data.ByteString
import qualified Crypto.Hash.SHA256 as SHA256

import Crypto.Hash.SHA256 (hashlazy)
import qualified Data.ByteString as Strict
import qualified Data.ByteString.Lazy as Lazy
import System.Process (system)
import Text.Printf (printf)

import System.Directory.PathWalk
import System.Posix.Files

import Data.ByteString.Builder

import qualified Data.Text as T
import Data.Text(pack, unpack, replace)

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
    let fullpath = dir ++ "/" ++ file
    -- let trimpath = replacedoubleslash fullpath
    -- print trimpath
    let fullpath' = unpack $ replace (pack path) "" (pack fullpath)
    -- let hash' = printf "%02x" (Strict.unpack $ hashFile fullpath)
    hashFile fullpath >>= putStr . toHex
    putStrLn $ "  ." ++ fullpath'
    -- print $ T.replace path "" "foo"
    -- when (getSymbolicLinkStatus file . isSymbolicLink) $ do
      -- hashFile file >>= putStrLn . toHex

main :: IO ()
main = do
    -- print_sha
    -- print_sha2
    -- hashFile path >>= putStrLn . toHex
    let path = "../test_dir"
    my_walk path
