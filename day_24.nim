import strscans
import strutils
import tables
import sets

type Component = (int, int)

proc max_strength(components: seq[Component]): int =
  type State = (int, set[uint16], int) 

  var start: State = (0, {}, 0)
  var q: seq[State] = @[start]

  var max_strength = -1

  var iters = 0
  while q.len > 0:
    let (port, taken, strength) = q.pop
    iters += 1
    
    if strength > max_strength:
      max_strength = strength
    
    for i in 0.uint16..<components.len.uint16:
      if i notin taken:
        if components[i][0] == port:
          q.add((components[i][1], taken + {i}, strength + components[i][0] + components[i][1]));
        elif components[i][1] == port:
          q.add((components[i][0], taken + {i}, strength + components[i][0] + components[i][1]));
    
  echo("Iterations: ", iters)
  return max_strength
  
  
proc read_input(): seq[Component] =
  for line in stdin.lines:
    var (port1, port2) = (0, 0)
    if scanf(line, "$i/$i", port1, port2):
      result.add((port1, port2))
    
let components = read_input()

proc part_one() =
  echo(max_strength(components))
  
proc max_strength_length(components: seq[Component]): int =
  type State = (int, HashSet[Component], int, int) 
  var ports: array[100, HashSet[Component]]
  for i in 0..<100:
    ports[i] = initHashSet[Component]()
  
  for c in components:
    ports[c[0]].incl(c)
    ports[c[1]].incl(c)

  var start: State = (0, initHashSet[Component](), 0, 0)
  var q: seq[State] = @[start]

  var max = (0, 0)

  while q.len > 0:
    let (port, taken, length, strength) = q.pop

    if (length, strength) > max:
      max = (length, strength)
    
    for c in ports[port] - taken:
        var new_taken = taken
        new_taken.incl(c)
        if c[0] == port:
          q.add((c[1], new_taken, length + 1, strength + c[0] + c[1]));
        elif c[1] == port:
          q.add((c[0], new_taken, length + 1, strength + c[0] + c[1]));
    
  return max[1]
  
  
proc part_two() =
  echo(max_strength_length(components))
  
part_two()