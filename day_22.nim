import sets
import tables

type Pos = (int, int)
type Dir = (int, int)

const (UP, DOWN, LEFT, RIGHT) = ((-1, 0), (1, 0), (0, -1), (0, 1))
const DIRS = [LEFT, DOWN, RIGHT, UP]

func turn_left(d: Dir): Dir = 
  let i = DIRS.find(d)
  return DIRS[(i + 1) mod 4]
  
func turn_right(d: Dir): Dir =
  let i = DIRS.find(d)
  return DIRS[(i + 3) mod 4]
  
func opposite(d: Dir): Dir = 
  let i = DIRS.find(d)
  return DIRS[(i + 2) mod 4]
  
func `+=`(p: var Pos, d: Dir) =
  p[0] += d[0]
  p[1] += d[1]

type VirusCarrier = object
  pos: Pos
  dir: Dir

proc act(infected: var HashSet[Pos], v: var VirusCarrier) =
  let is_infected = infected.contains(v.pos)
  v.dir = if is_infected: v.dir.turn_right else: v.dir.turn_left
  
  if not is_infected:
    infected.incl(v.pos)
  else:
    infected.excl(v.pos)
    
  v.pos += v.dir
  
proc read_input(): (HashSet[Pos], int, int) =
  var height = 0
  var width = 0
  var infected = initHashSet[Pos]()
  for line in stdin.lines:
    width = line.len
    for (j, c) in line.pairs:
      if c == '#':
        infected.incl((height, j)) 
        
    height += 1
    
  return (infected, height, width)
  

var (infected, height, width) = read_input()
var virus = VirusCarrier(pos: (height div 2, width div 2), dir: UP)

const rounds = 10000000

proc part_one() =
  var infections = 0
  for _ in 1..rounds:
    let old_size = infected.len
    act(infected, virus)
    
    if infected.len == old_size + 1:
      infections += 1
      
  echo(infections)
    

type NodeState = enum
  Weakened, Infected, Flagged, Clean
  
func act2(node_state: var Table[Pos, NodeState], v: var VirusCarrier): bool =
  var next_state = Clean
  let current_state = if node_state.contains(v.pos): node_state[v.pos] else: Clean
  case current_state
  of Clean:
    next_state = Weakened
    v.dir = v.dir.turn_left
  of Weakened:
    next_state = Infected
  of Infected:
    next_state = Flagged
    v.dir = v.dir.turn_right
  of Flagged:
    next_state = Clean
    v.dir = v.dir.opposite

  if next_state == Clean:
    node_state.del(v.pos)
  else:
    node_state[v.pos] = next_state
  
  v.pos += v.dir
  return next_state == Infected
  
proc part_two() =
  var node_state = initTable[Pos, NodeState]()
  for pos in infected:
    node_state[pos] = Infected
    
  var infections = 0
  for _ in 1..rounds:
    if act2(node_state, virus):
      infections += 1
      
  echo(infections)
  
part_two()