import sequtils
import strutils
import sugar

proc hash_round(list: seq[int], length: int, start: int = 0, skip: int = 0): (seq[int], int, int) =
  var i = start 
  var skip = skip 
  
  var list = list
  let n = list.len

  for j in 0..<length div 2:
    swap(list[(i + j) mod n], list[(i + length - j - 1) mod n])

  i += (length + skip) mod n
  skip += 1
    
  (list, i, skip)

      

let lines = stdin.lines.toSeq
let total_len = lines[0].parseInt
let list = (0..<total_len).toSeq

proc part_one() =
  let lengths = lines[1].split(",").map(x => x.strip.parseInt)
  var (list, i, skip) = (list, 0, 0)
  for l in lengths:
    (list, i, skip) = hash_round(list, l, i, skip)
    
  echo(list[0] * list[1])
  

func to_hex(b: int): string =
  let digits = "0123456789abcdef"
  var s: string = ""
  s.add(digits[b div 16])
  s.add(digits[b mod 16])
  
  s
  
proc part_two() =
  for line in lines[1..<lines.len]:
    var lengths: seq[int] = @[]
    for c in line.strip:
      lengths.add(ord(c))
    lengths = concat(lengths, @[17, 31, 73, 47, 23])
    
    var list = list
    let rounds = 64

    var (i, skip) = (0, 0)
    for r in 0..<rounds:
      for l in lengths:
          (list, i, skip) = hash_round(list, l, i, skip)
    
    var chunks: seq[int] = @[]
    var chunk_start = 0
    while chunk_start < list.len:
      var chunk_val = 0
      for i in 0..15:
        chunk_val = chunk_val xor list[chunk_start + i]
      
      chunks.add(chunk_val)
      chunk_start += 16
      
    let final_hash = chunks.map(x => to_hex(x)).join("")
    echo(final_hash)
  
part_two()
