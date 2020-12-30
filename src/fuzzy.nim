# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

import system
import strutils
from algorithm import sorted
# from std/editdistance import editDistanceAscii  # stdlib one yields correct distance BUT for ratio cost should be higher because yields better results (Python does that too)

proc levenshtein_ratio_and_distance*(s, t: string, ratio_calc = true): float =
  ## This should be very similar to python implementation
  ## Calculates ratio and distance depending on `ratio_calc`
  let rows = s.len + 1
  let cols = t.len + 1
  var distance: seq[seq[int]]
  var cost: int
  distance = newSeq[seq[int]](rows)
  for i in 0 ..< rows:
    distance[i] = newSeq[int](cols)
  for i in 1 ..< rows:
    for k in 1 ..< cols:
      distance[i][0] = i
      distance[0][k] = k

  for col in 1 ..< cols:
    for row in 1 ..< rows:
      if s[row - 1] == t[col - 1]:
        cost = 0
      else:
        if ratio_calc:
          cost = 2
        else:
          cost = 1
      distance[row][col] = min(min(distance[row-1][col] + 1,
                                   distance[row][col - 1] + 1),
                               distance[row-1][col - 1] + cost)
  let dst = distance[rows - 1][cols - 1]
  if ratio_calc:
    # echo s, " - ", t, " = ", $(((s.len + t.len) - dst).float / (s.len + t.len).float)
    return ((s.len + t.len) - dst).float / (s.len + t.len).float
  else:
    return dst.float


# proc levenshtein_ratio_and_distance*(s, t: string, ratio_calc=true): float =
#   ## stdlib distance is suboptimal for that case because here we mostly need
#   ## cost = 2
#   var dst = editDistanceAscii(s, t)
#   if ratio_calc:
#     return ((s.len + t.len) - dst).float / (s.len + t.len).float
#   return dst.float


proc fuzzyMatch*(s1, s2: string): float =
  ## Just basic fuzzy match
  ## Could be used as a base for other algorithms
  if s1.len > s2.len:
    return levenshtein_ratio_and_distance(s2, s1, ratio_calc = true)
  return levenshtein_ratio_and_distance(s1, s2, ratio_calc = true)


proc fuzzyMatchSmart*(s1, s2: string, withSubstring = true): float =
  ##Tries to be smart about the strings so:
  ## - lowercase
  ## - sorts substrings
  ## - best matching substring of length of shorter one
  var str1: string
  var str2: string
  str1 = s1.toLower
  str2 = s2.toLower
  str1 = str1.split(" ").sorted().join(" ")
  str2 = str2.split(" ").sorted().join(" ")
  if str1 == str2:
    return 1.0
  if str1.len == str2.len:
    return fuzzyMatch(str1, str2)
  var shorter, longer: string
  if str1.len < str2.len:
    shorter = str1
    longer = str2
  else:
    shorter = str2
    longer = str1
  var tmpRes = fuzzyMatch(shorter, longer)
  if withSubstring:
    let lengthDiff = longer.len - shorter.len
    var subMatch: float
    for i in 0 .. lengthDiff:
      subMatch = fuzzyMatch(shorter, longer[i ..< i + shorter.len])
      tmpRes = max(tmpRes, subMatch)
  return tmpRes
