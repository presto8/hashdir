import System.Directory.PathWalk

main = putStrLn "hello, world"

pathWalk "some/directory" $ \root dirs files -> do
  forM_ files $ \file ->
    when (".hs" `isSuffixOf` file) $ do
      putStrLn $ joinPath [root, file]


