import sequtils
import strscans

proc read_starting_values(): (int, int) = 
  let lines = stdin.lines.toSeq
  
  var val1: int
  var val2: int
  discard scanf(lines[0], "Generator A starts with $i", val1)
  discard scanf(lines[1], "Generator B starts with $i", val2)
  
  return (val1, val2)

func generator(multiplier: int, modulo: int): proc(prev: int): int {.noSideEffect.} =
  return func(prev: int): int =
    return (prev * multiplier ) mod modulo
    
proc part_one() =
  let (start1, start2) = read_starting_values()
  
  let g1 = generator(16807, 2147483647)
  let g2 = generator(48271, 2147483647)

  var (prev1, prev2) = (start1, start2)
  var result = 0
  const N = 40_000_000

  for i in 0..<N:
    let (next1, next2) = (g1(prev1), g2(prev2))
    
    let mask = (1 shl 16) - 1
    result += (if (next1 and mask) == (next2 and mask): 1 else: 0)
    
    (prev1, prev2) = (next1, next2)
    
  echo(result)
  
proc part_two() =
  let (start1, start2) = read_starting_values()
  
  let g1 = generator(16807, 2147483647)
  let g2 = generator(48271, 2147483647)

  var (prev1, prev2) = (start1, start2)
  var result = 0
  const N = 5_000_000

  for i in 0..<N:

    var (next1, next2) = (g1(prev1), g2(prev2))
    while next1 mod 4 != 0:
      next1 = g1(next1)
    while next2 mod 8 != 0:
      next2 = g2(next2)
    
    let mask = (1 shl 16) - 1
    result += (if (next1 and mask) == (next2 and mask): 1 else: 0)
    
    (prev1, prev2) = (next1, next2)
    
  echo(result)
  
part_two()