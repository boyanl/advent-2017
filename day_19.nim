import strutils
import sequtils

type Pos = (int, int)

func r(p: Pos): int =
  return p[0]
  
func c(p: Pos): int =
  return p[1]
  
func `+`(p: Pos, d: (int, int)): Pos =
  return (p[0] + d[0], p[1] + d[1])
  
type Direction = enum
  Left, Right, Up, Down
  
const DIRS = [Down, Right, Up, Left]

func to_left(d: Direction): Direction =
  let i = DIRS.find(d)
  return DIRS[(i + 1) mod 4]
  
func to_right(d: Direction): Direction =
  let i = DIRS.find(d)
  return DIRS[(i + 3) mod 4]

let tracks = stdin.lines.toSeq

proc find_starting_pos(): Pos =
  let x = tracks[0].find('|')
  return (0, x)
  
func next_along_dir(p: Pos, d: Direction): Pos =
  let i = DIRS.find(d)
  return p + [(1, 0), (0, 1), (-1, 0), (0, -1)][i]
  

proc follow(start: Pos): (string, int) =
  var dir = Down
  var pos = start
  var encountered = ""
  var steps = 1
  
  while true:
    let next_pos = next_along_dir(pos, dir)
    
    if next_pos.r < 0 or next_pos.r >= tracks.len or next_pos.c < 0 or next_pos.c >= tracks[0].len:
      break
    let c = tracks[next_pos.r][next_pos.c]
    
    if c.isAlphaAscii:
      encountered.add(c)
    elif c == '+':
      let next_dirs = [to_left(dir), to_right(dir)]
      for d in next_dirs:
        var after_next = next_along_dir(next_pos, d)
        if tracks[after_next.r][after_next.c] != ' ':
           dir = d
           break
    elif c == ' ':
      break
    
    pos = next_pos
    steps += 1
  
  return (encountered, steps)
        
proc part_one() =
  let (encountered, _) = follow(find_starting_pos())
  echo(encountered)
  
proc part_two() =
  let (_, steps) = follow(find_starting_pos())
  echo(steps)

part_two()