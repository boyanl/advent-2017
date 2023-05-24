import strutils

func toDigit(c: char): int =
    int(c) - int('0')

proc part_one() =
    for line in stdin.lines:
        var result = 0
        for i in 0..<line.len:
            if line[i] == line[(i+1) mod line.len]:
                result += line[i].toDigit
                
        echo(result)
        
proc part_two() =
    for line in stdin.lines:
        var result = 0
        for i in 0..<line.len:
            let mid = line.len div 2
            if line[i] == line[(mid + i) mod line.len]:
                result += line[i].toDigit

        echo(result)
            

part_two()