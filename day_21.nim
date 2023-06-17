import strutils
import strscans
import tables

func block_size(s: string): int =
  case s.len:
    of 4: return 2
    of 9: return 3
    of 16: return 4
    else: return -1

func block_val(s: string, i: int, j: int): char =
  let n = s.block_size 
  return s[i*n + j]

func rotate(s: string): string =
  let n = if s.len == 4: 2 else: 3
  for i in 0..<n:
    for j in 0..<n:
      let c = s.block_val(n - j - 1, i)
      result.add(c)
      
func reverse(s: string): string =
  for i in 0..<s.len:
    result.add(s[s.len - i - 1])
      
func flip(s: string): string =
  let n = s.block_size
  for i in 0..<n:
    let row = s[i*n..<(i+1)*n].reverse
    result.add(row)
    
proc read_rules(): Table[string, string] =
  var rules = initTable[string, string]()
  for line in stdin.lines:
    var left: string
    var right: string

    if scanf(line, "$* => $*", left, right):
      left = left.replace("/", "")
      right = right.replace("/", "")
      
      var rotated = left
      for r in 0..3:
        rules[rotated] = right
        rules[rotated.flip] = right
        rotated = rotated.rotate

  return rules    
  
func get_block(s: seq[string], i: int, j: int, n: int): string =
  for di in 0..<n:
    for dj in 0..<n:
      result.add(s[i + di][j + dj])
      
func set_block(s: var seq[string], i: int, j: int, bl: string) =
  let n = bl.block_size
  for di in 0..<n:
    for dj in 0..<n:
      s[i + di][j + dj] = block_val(bl, di, dj)
  
  
func apply_rules(state: seq[string], rules: Table[string, string]): seq[string] =
  let n = (if state.len mod 2 == 0: 2 else: 3)
  let new_size: int = (if state.len mod 2 == 0: 3*(state.len div 2) else: 4*(state.len div 3))
  var res = newSeq[string](new_size)
  for i in 0..<new_size:
    res[i] = newString(new_size)
  
  for i in 0..<state.len div n:
    for j in 0..<state.len div n:
      let b = get_block(state, i*n, j*n, n)
      let new_b = rules[b]
      set_block(res, i*(n+1), j*(n+1), new_b)

  res
  
func pixels_count(s: seq[string]): int =
  var total = 0
  for str in s:
    total += str.count('#')
    
  total

  
func to_displayable(s: string): seq[string] =
  let n = s.block_size
  
  for i in 0..<n:
    result.add(s[i*n..<(i+1)*n])
    
proc display(strings: seq[string]) =
  for s in strings:
    echo(s)
    
let start = @[".#.", "..#", "###"]
let rules = read_rules()

proc part_one() =
  const rounds = 5
  var current = start
  for i in 1..rounds:
    current = current.apply_rules(rules)
    
  let result = current.pixels_count
  echo(result)
  
proc part_two() = 
  const rounds = 18
  var current = start
  for i in 1..rounds:
    current = current.apply_rules(rules)
    
  let result = current.pixels_count
  echo(result)
  
part_two()