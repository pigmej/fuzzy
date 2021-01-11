# Fuzzy search library for nim

There are two important methods `fuzzyMatch` and `fuzzyMatchSmart`.


the usage is really straight forward:

``` nim
var s1 = "foo bar baz"
var s2 = "bAz"
var s3 = "fobz"
var s4 = "bra"

echo fuzzyMatchSmart(s1, s2)  # => 1.0
echo fuzzyMatchSmart(s1, s3)  # => 0.5
echo fuzzyMatchSmart(s1, s4)  # => 0.6

`fuzzyMatchSmart` tries to be smart about the strings so it does:
- lowercase whole string
- sorts substrings splitted by `" "`
- best matching substring of the length of the shorter one
```
