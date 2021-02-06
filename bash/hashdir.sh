#!/usr/bin/env bash

set -euo pipefail

main() {
    hash=$(get_hashes "$1" | sort | sha256sum | cut -c1-8)
    echo "$hash  $1"
}

get_hashes() (
    cd "$1" &>/dev/null
    find . '(' -type f -o -type l ')' | while read -r path; do
        if [[ -L $path ]]; then
            # need the hack below otherwise readlink will echo a newline
            echo -n "$(readlink "$path")" | sha256sum | awk "{ print \$1 \"  $path\"}"
        else
            sha256sum "$path"
        fi
    done
)

main "$@"
