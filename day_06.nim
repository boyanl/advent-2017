import sequtils
import strutils
import sugar
import sets
import tables

func redistribute(banks: seq[int]): seq[int] =
    result = banks
    let maxIdx = banks.maxIndex
    let (d, r) = (banks[maxIdx] div banks.len, banks[maxIdx] mod banks.len)

    result[maxIdx] = 0
    for i in 0..<banks.len:
        result[i] += d
    for i in 1..r:
        result[(maxIdx + i) mod banks.len] += 1
    
    return result
    
proc part_one(banks: seq[int]) =
    var seen = initHashSet[seq[int]]()
    
    var banks = banks
    seen.incl(banks)
    var cycles = 0
    while true:
        let next = redistribute(banks)
        cycles += 1
        if seen.contains(next):
            break
        banks = next
        seen.incl(banks)
    
    echo(cycles)
    
proc part_two(banks: seq[int]) =
    var seen_at = initTable[seq[int], int]()

    var banks = banks
    seen_at[banks] = 0
    var cycle = 0
    var cycle_len = 0
    while true:
        let next = redistribute(banks)
        cycle += 1
        if seen_at.hasKey(next):
            cycle_len = cycle - seen_at[next]
            break
        banks = next
        seen_at[banks] = cycle
    
    echo(cycle_len)

for line in stdin.lines:
    var banks = line.split.map(x => x.parseInt)
    part_two(banks)