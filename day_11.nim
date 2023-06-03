import strutils

type Pos = object
  x, y: int

func go(pos: Pos, dir: string): Pos =
  case dir
  of "n":
    return Pos(x: pos.x, y: pos.y + 2)
  of "s": return Pos(x: pos.x, y: pos.y - 2)
  of "ne": return Pos(x: pos.x + 2, y: pos.y + 1)
  of "nw": return Pos(x: pos.x - 2, y: pos.y + 1)
  of "se": return Pos(x: pos.x + 2, y: pos.y - 1)
  of "sw": return Pos(x: pos.x - 2, y: pos.y - 1)
  
func steps_from_origin(pos: Pos): int =
  var steps_x = (pos.x div 2).abs
  var steps_y = max((pos.y.abs - steps_x) div 2, 0)
  
  steps_x + steps_y

proc part_one() =
  for line in stdin.lines:
    var pos = Pos(x: 0, y: 0)
    let directions = line.split(",")
    
    for dir in directions:
      pos = go(pos, dir)
      
    echo(steps_from_origin(pos))
    
proc part_two() = 
  for line in stdin.lines:
    var pos = Pos(x: 0, y: 0)
    let directions = line.split(",")
    
    var max_dist = -1
    for dir in directions:
      pos = go(pos, dir)
      let d = steps_from_origin(pos)
      if d > max_dist:
        max_dist = d

    echo(max_dist)
  
part_two()