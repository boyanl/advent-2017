import strscans

proc read_levels(): seq[(int, int)] =
  var levels: seq[(int, int)] = @[]
  for line in stdin.lines:
    
    var (index, depth) = (0, 0)
    if scanf(line, "$i: $i", index, depth):
      levels.add((index, depth))
  
  return levels
  
func severity(levels: seq[(int, int)], delay: int = 0): int = 
  var total = 0
  for (idx, depth) in levels:
    let at = idx + delay
    let t = depth - 1
    let period = 2*t
    let scanner_pos = t - ((at mod period) - t).abs
    
    if scanner_pos == 0:
      total += idx * depth
  
  total
  
func get_caught_at(levels: seq[(int, int)], delay: int = 0): seq[int] = 
  for (idx, depth) in levels:
    let at = idx + delay
    let t = depth - 1
    let period = 2*t
    let scanner_pos = t - ((at mod period) - t).abs
    
    if scanner_pos == 0:
      result.add(idx)
      
  
  result

    
let levels = read_levels()

proc part_one() =
  let result = severity(levels)
  echo(result)
  

proc part_two() =
  var delay = 0
  while true:
    if get_caught_at(levels, delay).len == 0:
      echo(delay)
      break
    delay += 1
    
  
part_two()