import sequtils
import strutils
import sets
import sugar
import algorithm

proc part_one() =
    let result = stdin.lines.toSeq.filter(func (line: string): bool =
        let words = line.split
        return words.len == words.toHashSet.len
    ).len
    echo(result)
    

    
proc part_two() =
    let result = stdin.lines.toSeq.filter(proc (line: string): bool =
        let words = line.split
        let different = words.map(w => w.toSeq.sorted).toHashSet
        return words.len == different.len
    ).len
    echo(result)
    
part_two()