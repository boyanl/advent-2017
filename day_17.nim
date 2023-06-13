import sequtils

proc addWithSpinlock(vals: var seq[int], v: int, currentPos: int, skip: int): int =
  if vals.len == 0:
    vals.add(v)
    return 0

  var next_pos = (currentPos + skip + 1) mod vals.len
  vals.insert(v, next_pos)
  
  return next_pos
  
proc spinlockSeq(n: int, skip: int): (seq[int], int) =
  var vals: seq[int] = @[]
  var currentPos = 0

  for i in 0..n:
    currentPos = addWithSpinlock(vals, i, currentPos, skip)
    
  return (vals, currentPos)

let skip = 348

proc part_one() =
  let upto = 2017
  let (ns, pos) = spinlockSeq(upto, skip)
  echo(ns[(pos + 1) mod ns.len])
  
proc part_two() =
  var ns: array[2, int] = [0, 1]
  let upto = 50_000_000

  var currentIdx = 1
  for i in 2..upto:
    var nextIdx = (currentIdx + skip + 1) mod i
    if nextIdx == 0:
      nextIdx = i
      
    if nextIdx == 1:
      ns[1] = i
    currentIdx = nextIdx
  
  echo(ns[1])


part_two()