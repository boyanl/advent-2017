import strutils
import strscans
import strformat
import tables
import sequtils

type Condition = enum
    LessThan, LessThanEqual, GreaterThan, GreaterThanEqual, Equal, NotEqual

type Instruction = object
    register: string
    delta: int
    conditionReg: string
    conditionType: Condition
    conditionArg: int

proc read_input(): seq[Instruction] =
    for line in stdin.lines:
        var target, deltaType, conditionReg, op: string
        var delta, conditionArg: int
        if scanf(line, "$* $* $i if $* $* $i", target, deltaType, delta, conditionReg, op, conditionArg):
            if deltaType == "dec":
                delta = -delta
            let conditionType = case op
            of "<=": LessThanEqual
            of "<": LessThan
            of ">=": GreaterThanEqual
            of ">": GreaterThan
            of "==": Equal
            of "!=": NotEqual
            else: LessThan

            result.add(Instruction(register: target, delta: delta, conditionReg: conditionReg, conditionType: conditionType, conditionArg: conditionArg))
            
func check(regVal: int, op: Condition, conditionArg: int): bool =
    return case op:
    of LessThanEqual: regVal <= conditionArg
    of LessThan: regVal < conditionArg
    of GreaterThanEqual: regVal >= conditionArg
    of GreaterThan: regVal > conditionArg
    of Equal: regVal == conditionArg
    of NotEqual: regVal != conditionArg
            
proc execute(instructions: seq[Instruction]): Table[string, int] =
    var registers = initTable[string, int]()
    
    for instr in instructions:
        var conditionRegVal = registers.getOrDefault(instr.conditionReg, 0)
        if check(conditionRegVal, instr.conditionType, instr.conditionArg):
            let currentVal = registers.getOrDefault(instr.register, 0)
            registers[instr.register] = currentVal + instr.delta

    return registers


proc part_one() = 
    let instructions = read_input()
    let registers = execute(instructions)
    let maxVal = registers.values.toSeq.max
    echo(maxVal)
    
proc executeAndTrackMax(instructions: seq[Instruction]): int = 
    var registers = initTable[string, int]()
    
    var maxVal = 0
    for instr in instructions:
        var conditionRegVal = registers.getOrDefault(instr.conditionReg, 0)
        if check(conditionRegVal, instr.conditionType, instr.conditionArg):
            let currentVal = registers.getOrDefault(instr.register, 0)
            registers[instr.register] = currentVal + instr.delta
            if currentVal + instr.delta > maxVal:
                maxVal = currentVal + instr.delta

    return maxVal
    
proc part_two() = 
    let instructions = read_input()
    let maxVal = executeAndTrackMax(instructions)
    echo(maxVal)
    
part_two()