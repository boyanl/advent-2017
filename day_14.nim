import sequtils
import strutils
import sugar
import bitops
import sets

proc hash_round(list: seq[uint8], length: int, start: int = 0, skip: int = 0): (seq[uint8], int, int) =
  var i = start 
  var skip = skip 
  
  var list = list
  let n = list.len

  for j in 0..<length div 2:
    swap(list[(i + j) mod n], list[(i + length - j - 1) mod n])

  i += (length + skip) mod n
  skip += 1
    
  (list, i, skip)
  

func knothash(s: string): array[16, uint8] =
  let n = 256 
  let rounds = 64

  var lengths: seq[int] = @[]
  for c in s.strip:
    lengths.add(ord(c))
  lengths = concat(lengths, @[17, 31, 73, 47, 23])
  
  var list = (0..<n).toSeq.map(x => uint8(x))

  var (i, skip) = (0, 0)
  for r in 0..<rounds:
    for l in lengths:
        (list, i, skip) = hash_round(list, l, i, skip)
  
  var chunks: seq[uint8] = @[]
  var chunk_start = 0
  while chunk_start < list.len:
    var chunk_val = uint8(0)
    for i in 0..15:
      chunk_val = chunk_val xor list[chunk_start + i]
    
    chunks.add(chunk_val)
    chunk_start += 16
    
  for i in 0..15:
    result[i] = chunks[i]

let key = stdin.lines.toSeq[0]

proc part_one() = 
  var bits_set = 0
  for i in 0..127:
    let row_key = key & "-" & $i
    let bytes = knothash(row_key)
    
    for b in bytes:
      bits_set += b.popcount 
      
  echo(bits_set)

proc regions_count(grid: array[128, array[128, bool]]): int =
  var visited = initHashSet[(int, int)]()
  var count = 0
  
  for i in 0..127:
    for j in 0..127:
      if grid[i][j] == true and not visited.contains((i, j)):
        count += 1

        let start = (i, j)
        var q: seq[(int, int)] = @[start]
        visited.incl(start)
        
        var in_region = 0

        while q.len > 0:
          let pos = q.pop
          in_region += 1
          
          for (dy, dx) in [(0, -1), (0, 1), (-1, 0), (1, 0)]:
            let (ny, nx) = (pos[0] + dy, pos[1] + dx)
            if nx >= 0 and nx < 128 and ny >= 0 and ny < 128 and grid[ny][nx] and (not visited.contains((ny, nx))):
              q.add((ny, nx))
              visited.incl((ny, nx))
  
  count
      
proc part_two() =
  var grid: array[128, array[128, bool]]
  
  var cnt = 0
  for i in 0..127:
    let row_key = key & "-" & $i
    let bytes = knothash(row_key)
    
    for j, b in bytes.pairs:
      for d in 0..7:
        grid[i][j*8 + (7 - d)] = (if (int(b) and (1 shl d)) == 0: false else: true)
  
  let result = regions_count(grid)
  echo(result)
        
  
part_two()