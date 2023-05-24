import strutils
import sequtils
import sugar

proc part_one() =
    var total = 0
    for line in stdin.lines:
        let ns = line.split().map(x => x.parseInt)
        
        total += ns.max - ns.min
        
    echo(total)
    
proc part_two() = 
    var total = 0
    for line in stdin.lines:
        let ns = line.split().map(x => x.parseInt)
        
        for i in 0..<ns.len:
            for j in i+1..<ns.len:
                if (ns[i] mod ns[j] == 0) or (ns[j] mod ns[i] == 0):
                    total += (if ns[i] < ns[j]: (ns[j] div ns[i]) else: (ns[i] div ns[j]))
        
    echo(total)
    
part_two()