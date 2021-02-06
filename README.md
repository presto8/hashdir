Hashdir computes a single hash for a path that can be used to compare the path
with other paths to see if they are identical.

Only the file's full path name (relative to its parent directory) and contents
are used to determine uniqueness; other attributes, like modification time,
file permissions, or owner, are not used.

The method used is to:
- Go through all regular files and links in the specified path, recursively
  descending directories
  - Skip non-regular files like pipes
  - Don't follow symlinks; instead, use the contents of the symlink (e.g., the target)
  - If a permission error is encountered, report an error and exit without printing a hash
- Display the hash for the file plus the relative file path, similar to the output of sha256sum
  hash + "  ./" + relativepath + newline
  (format is intended to match output of sha256sum/sha256deep)
- Sort alphabetically by the hash value
- Compute the hash of that single combined string
- Output the first 8 characters of the final hash value plus a space plus the original path
  abcdefgh the/path/here

If the path contains only regular files and directories (no symlinks), the
output should match the following:

    ( cd path && sha256deep -rl . | sort | sha256sum )

As a research project to learn more languages, I will implement hashdir in many languages:

- Bash
- Python
- Rust
- Go
- Haskell
- Nim
