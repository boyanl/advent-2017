import tables

func `+`(pos1: (int, int), pos2: (int, int)): (int, int) =
    (pos1[0] + pos2[0], pos1[1] + pos2[1])
    
func `*`(n: int, pos: (int, int)): (int, int) =
    (n * pos[0], n * pos[1])
    
func dist(pos1: (int, int), pos2: (int, int)): int =
    (pos1[0] - pos2[0]).abs + (pos1[1] - pos2[1]).abs

proc getCoords(n: int): (int, int) =
    let ds = [(1, 0), (0, 1), (-1, 0), (0, -1)]

    var current = 1
    var pos = (0, 0)
    var dir_idx = 0
    var (turns, steps) = (0, 0)
    var r = 1
    
    while current < n:
        current += 1 
        steps += 1
        pos = pos + ds[dir_idx]
        
        if steps mod r == 0:
            dir_idx = (dir_idx + 1) mod ds.len
            turns += 1
            steps = 0
        if turns == 2:
            r += 1
            turns = 0

    pos
    
let puzzle_input = 361527
proc part_one() =
    let origin = (0, 0)
    let coords = getCoords(puzzle_input)
    echo(dist(coords, origin))
    
iterator directions(): (int, int) =
    for i in -1..1:
        for j in -1..1:
            if i != 0 or j != 0:
                yield (i, j)
    
proc generateFancyUntilReached(n: int): int =
    let ds = [(1, 0), (0, 1), (-1, 0), (0, -1)]

    var current = 1
    var pos = (0, 0)
    var dir_idx = 0
    var (turns, steps) = (0, 0)
    var r = 1
    
    var values = initTable[(int, int), int]()
    values[(0, 0)] = 1
    
    while current < n:
        steps += 1
        pos = pos + ds[dir_idx]

        var current = 0
        for d in directions():
            if values.contains(pos + d):
                current += values[pos + d]
            
        values[pos] = current
        
        if current > n:
            return current
        
        if steps mod r == 0:
            dir_idx = (dir_idx + 1) mod ds.len
            turns += 1
            steps = 0
        if turns == 2:
            r += 1
            turns = 0

proc part_two() =
    let result = generateFancyUntilReached(puzzle_input)
    echo(result)
    
part_two()