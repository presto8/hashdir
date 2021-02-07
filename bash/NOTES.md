I have many years' experience with shell programming.

Shell programming is very easy to get started since I can just start with the
commands I normally use and build upon it iteratively.

set -eux -o pipefail makes shell programming much safer.

Using unix commands (like sha256sum and find) is usually very fast, since these
programs have been heavily optimized and are time proven.

Still, little corner cases crop up that requiring debugging: while writing this
script, I was using "cd" to go into a path; I didn't realize that changing a
directory in a script outputs the new pathname to stdout. So I had to pipe its
output to /dev/null.

Another minor annoyance was getting a symlink's contents without a newline at
the end, requiring a hack using echo -n.

Unfortunately shell programming is full of corner cases like this.
