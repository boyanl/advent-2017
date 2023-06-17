import sequtils
import strscans
import tables

type Vec3 = (int, int, int)

type Particle = object
  p, v, a: Vec3
  

func dist(p: Vec3): int =
  return p[0].abs + p[1].abs + p[2].abs
  
func `+`(v1, v2: Vec3): Vec3 =
  return (v1[0] + v2[0], v1[1] + v2[1], v1[2] + v2[2])
  
func `+=`(v1: var Vec3, v2: Vec3) =
  v1[0] += v2[0]
  v1[1] += v2[1]
  v1[2] += v2[2]
  

proc read_particles(): seq[Particle] = 
  var particles: seq[Particle] = @[]
  for line in stdin.lines:
    var p: Vec3
    var v: Vec3
    var a: Vec3
    if scanf(line, "p=<$i,$i,$i>, v=<$i,$i,$i>, a=<$i,$i,$i>", p[0], p[1], p[2], v[0], v[1], v[2], a[0], a[1], a[2]):
      particles.add(Particle(p: p, v: v, a: a))
  
  return particles
  
let particles = read_particles()

proc part_one() =
  var min_idx = -1
  var min_dist = -1

  for (i, particle) in particles.pairs:
    if min_dist == -1 or dist(particle.a) < min_dist:
      min_dist = dist(particle.a)
      min_idx = i

  echo(min_idx)
  
proc part_two() = 
  var current = particles

  for _ in 0..1000:
    var positions = initTable[Vec3, seq[int]]()
    
    for (i, p) in current.mpairs:
      p.v += p.a
      p.p += p.v
      
      if not positions.hasKey(p.p):
        positions[p.p] = @[]
      positions[p.p].add(i)
      
    var next: seq[Particle] = @[]
    for k, v in positions:
      if v.len == 1:
        next.add(current[v[0]])
      
    current = next
    
  echo(current.len)
  
part_two()