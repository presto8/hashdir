getting started is easy

compiler is very forgiving, data types are similar to C

have to define data types explicitly, which feels redundant sometimes; for
example, if I declare the return type of a function, then I shouldn't need to
define it inside the function. Maybe it's possible and I just don't know how to
yet.

gofmt is nice so I don't have to worry about the formatting, like it or love
it, it is consistent

heavy emphasis on error handling code, much more in your face than other
languages; personally, I still prefer Python's 'try/except/raise' approach

The error handling code makes it much harder to simply look at the code and
follow it; on the other hand, it makes debugging a lot easier since it's very
easy to follow the error path

don't like the capitalization rules of go; they just don't work as I
intuitively expect them to, e.g., os.Readlink, should be os.ReadLink?

Generally, compiling is a lot like C; if it compiles, it still may crash at
runtime, and it also didn't work at run time as expected; big deperature from
Rust

First impressions, so far, I like Rust better than Go; Rust is harder, but the
issues seem to be first-time learning issues that once resolved would not be
blockers as much
