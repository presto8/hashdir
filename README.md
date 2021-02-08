# Overview

Hashdir computes a single hash for a path's contents that can be used to
compare the path with other paths to see if they are identical.

Only the file's full path name (relative to its parent directory) and contents
are used to determine uniqueness; other attributes, like modification time,
file permissions, or owner, are not used.

# Results (Quick Start)

Running the test harness will run all of the implementations and compare the results.

    ./test

# Methodology

The method used is to:
- Go through all regular files and links in the specified path, recursively
  descending directories
  - Skip non-regular files like pipes
  - Don't follow symlinks; instead, use the contents of the symlink (e.g., the target)
  - If a permission error is encountered, report an error and exit without printing a hash
- Create a string comprising the hexadecimal representation of the hash (in
  lowercsae) for the file plus the relative file path, similar to the output of
  sha256sum. Note: the string has a newline at the end.
    3bf3e00bb30a0dde6f70167c5273bc455e0621053e02965733130002dabbc1a6  ./dir1/dir2/test
  (format is intended to match output of sha256sum/sha256deep)
- Sort the individual strings alphabetically join them a single combined string
- Compute the hash of that single combined string
- Output the first 8 characters of the final hash value plus a space plus the original path
  abcdefgh the/path/here

If the path contains only regular files and directories (no symlinks), the
output should match the following:

    ( cd path && sha256deep -rl . | sort | sha256sum )

# Applied Research

As a way to gain experience in up and cominglanguages, I will implement hashdir
in the following:

## Reference Implemenations
- Bash (find + sha256sum)
- Python

## Learning Implementations
- Rust
- Go
- Haskell
- node/JavaScript
- Common Lisp (with SLY)
- Scala
- Clojure
- Nim
