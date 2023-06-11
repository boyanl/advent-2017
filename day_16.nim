import sequtils
import strutils
import strscans
import tables

proc spin(programs: var openArray[int], n: int) =
  var tmp = newSeq[int](n)
  for i in 0..<n:
    tmp[i] = programs[programs.len - (n - i)]
    
  for i in countdown(programs.len - n-1,0):
    programs[n + i] = programs[i]
    
  for i in 0..<n:
    programs[i] = tmp[i]
  
proc exchange(programs: var openArray[int], p1: int, p2: int) =
  swap(programs[p1], programs[p2])
  
proc partner(programs: var openArray[int], v1: int, v2: int) =
  let p1 = programs.find(v1)
  let p2 = programs.find(v2)
  
  exchange(programs, p1, p2)
  
proc stringified(programs: var openArray[int]): string =
  var s: string
  
  for v in programs:
    s.add(char(v + ord('a')))

  return s 
  
const N = 16
type Permutation = array[N, int]

func dance(programs: Permutation, instructions_line: string): Permutation =
  result = programs
  for instr in instructions_line.split(","):
    var (arg1, arg2) = (0, 0)
    var (name1, name2) = (' ', ' ')
    if scanf(instr, "s$i", arg1):
      spin(result, arg1)
    elif scanf(instr, "x$i/$i", arg1, arg2):
      exchange(result, arg1, arg2)
    elif scanf(instr, "p$c/$c", name1, name2):
      arg1 = ord(name1) - ord('a')
      arg2 = ord(name2) - ord('a')
      partner(result, arg1, arg2)
      
  
func identity(): Permutation =
  var r: Permutation
  for i in 0..r.high:
    r[i] = i
    
  return r


proc part_one() =
  var instructions_line = stdin.lines.toSeq[0]
  var final = dance(identity(), instructions_line)

  echo(stringified(final))
  
proc part_two() =
  var instructions_line = stdin.lines.toSeq[0]
  var current = identity()
  
  var seenAt = initTable[Permutation, int]()
  seenAt[current] = 0

  let N = 1_000_000_000
  var round = 1
  while round <= N:
    current = dance(current, instructions_line)
    if seenAt.hasKey(current):
      var cycleLen = round - seenAt[current]
      var cycles = (N - round) div cycleLen
      round += cycles * cycleLen
    else:
      seenAt[current] = round 
    
    round += 1
  
  echo(stringified(current))
  
  
part_two()
  