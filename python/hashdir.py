#!/usr/bin/env python3

import argparse
import hashlib
import os
import subprocess
import threading
import queue
from collections import namedtuple


def scandir_r(top):
    for i in os.scandir(top):
        if i.is_dir(follow_symlinks=False):
            yield from scandir_r(i.path)
        else:
            yield i


def hash_file(path):
    h = hashlib.sha256()
    if os.path.islink(path):
        h.update(os.readlink(path).encode())
    else:
        h.update(open(path, 'rb').read())
    return h.hexdigest()


def hash_path(path):
    shas = [(hash_file(x), x) for x in scandir_r(path)]
    shas.sort()

    h = hashlib.sha256()
    for sha, fpath in shas:
        fpath = fpath.path[len(path) + 1:]
        line = f"{sha}  ./{fpath}\n".encode()
        h.update(line)

    finalsha = h.hexdigest()[:8]

    return namedtuple('ShaResults', 'path sha')._make([path, finalsha])


def main():
    for path in args.pathspec:
        if os.path.isdir(path):
            result = hash_path(path)
            print(f"{result.sha}  {result.path}")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('pathspec', nargs='+', help='paths to add (dirs are recursively added)')
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    main()
