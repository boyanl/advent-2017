import strutils
import sequtils
import sugar

var jumps = stdin.lines.toSeq.map(x => x.parseInt)

proc part_one() =
    var i = 0;
    var steps_cnt = 0
    while i < jumps.len:
        let next = i + jumps[i]
        steps_cnt += 1
        if next < 0 or next >= jumps.len:
            break
            
        jumps[i] += 1
        i = next

    echo(steps_cnt)

proc part_two() =
    var i = 0;
    var steps_cnt = 0
    while i < jumps.len:
        let next = i + jumps[i]
        steps_cnt += 1
        if next < 0 or next >= jumps.len:
            break
            
        if jumps[i] >= 3:
            jumps[i] -= 1
        else:
            jumps[i] += 1
        i = next

    echo(steps_cnt)



part_two()