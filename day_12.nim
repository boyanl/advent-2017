import strutils
import sequtils
import strscans
import sugar
import tables
import sets

proc link(g: var Table[int, seq[int]], f: int, t: int) =
  if not g.hasKey(f):
    g[f] = @[]
  g[f].add(t)

  if not g.hasKey(t):
    g[t] = @[]
  g[t].add(f)
  

proc build_graph(): Table[int, seq[int]] = 
  var (from_door_str, to_doors_str) = ("", "")
  var g = initTable[int, seq[int]]()

  for line in stdin.lines:
    if scanf(line, "$+ <-> $+", from_door_str, to_doors_str):
      let from_door = from_door_str.parseInt
      let to_doors = to_doors_str.split(", ").map(x => x.parseInt)
      
      for to in to_doors:
        link(g, from_door, to)

  g
  
proc part_one() =
  let graph = build_graph()
  
  var q: seq[int] = @[]
  var visited = initHashSet[int]()
  q.add(0)
  visited.incl(0)
  
  var count = 0
  
  while q.len > 0:
    let curr = q.pop
    count += 1
    
    for next in graph[curr]:
      if not visited.contains(next):
        q.add(next)
        visited.incl(next)
    
  echo(count)
  
proc part_two() = 
  let graph = build_graph()

  var q: seq[int] = @[]
  var visited = initHashSet[int]()
  
  var count = 0
  for p in graph.keys:
    if not visited.contains(p):
      count += 1
      q.add(p)
      visited.incl(p)
      
      
      while q.len > 0:
        let curr = q.pop
        
        for next in graph[curr]:
          if not visited.contains(next):
            q.add(next)
            visited.incl(next)
    
  echo(count)
  
part_two()