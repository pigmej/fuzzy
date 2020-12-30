import fuzzy

# Test fuzzy
block:
  var s1 = "fooBar"
  var s2 = "foobar"
  var s3 = "fobar"
  var s4 = "other"
  var s5 = "foo bar"

  block:
    var result = levenshtein_ratio_and_distance(s1, s2, false)
    doAssert result == 1, $result

    result = levenshtein_ratio_and_distance(s1, s3, false)
    doAssert result == 2, $result

  block:
    var result1 = levenshtein_ratio_and_distance(s1, s2, true)
    var result2 = levenshtein_ratio_and_distance(s1, s3, true)
    var result3 = levenshtein_ratio_and_distance(s1, s4, true)
    doAssert result1 != 1
    doAssert result2 != 1
    doAssert result3 < result1, $result3


  block:
    var s1 = "foo bar baz"
    var s2 = "fobz"

    var result1 = levenshtein_ratio_and_distance(s1, s2, true)
    doAssert result1 > 0.5, $result1

  block:
    doAssert fuzzyMatch(s1, s4) < 0.7, $fuzzyMatch(s1, s4)
    doAssert fuzzyMatch(s1, s2) > 0.8, $fuzzyMatch(s1, s2)
    doAssert fuzzyMatch(s1, s5) > 0.7, $fuzzyMatch(s1, s5)


  block:
    var s1 = "bazz"
    var s2 = "bAz"
    var s3 = "baz"

    doAssert fuzzyMatchSmart(s1, s2) == fuzzyMatchSmart(s1, s3)
    doAssert fuzzyMatchSmart(s1, s2) == fuzzyMatchSmart(s2, s3)


  block:
    var s1 = "Some very long sentence with spaces and other stuff"
    var s2 = "and"
    var s3 = "with sentence"
    var s4 = "other long stuff"

    doAssert fuzzyMatchSmart(s1, s2) == 1, $fuzzyMatchSmart(s1, s2)
    doAssert fuzzyMatchSmart(s1, s3) > 0.5, $fuzzyMatchSmart(s1, s3)
    doAssert fuzzyMatchSmart(s1, s4) > 0.8, $fuzzyMatchSmart(s1, s4)
