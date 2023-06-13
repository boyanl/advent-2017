import sequtils
import strutils

proc regidx(regName: char): int =
  ord(regName) - ord('a')
  
proc getarg(arg: string, registers: openArray[int]): int =
  if arg[0].isLowerAscii:
    return registers[regidx(arg[0])]
  return arg.parseInt

let program = stdin.lines.toSeq

proc part_one() =
  var registers: array[26, int]
  var lastSounded = -1
  var ip = 0

  while true:
    if ip < 0 or ip >= program.len:
      break

    let instr = program[ip]
    let parts = instr.split

    let target = parts[1][0]
    let arg = if parts.len > 2: getarg(parts[2], registers) else: -1
    
    case parts[0]:
    of "snd":
      lastSounded = registers[regidx(target)]
    of "set":
      registers[regidx(target)] = arg
    of "add":
      registers[regidx(target)] += arg
    of "mul":
      registers[regidx(target)] *= arg
    of "mod":
      registers[regidx(target)] = registers[regidx(target)] mod arg
    of "rcv":
      if arg != 0:
        echo(lastSounded)
        break
    of "jgz":
      let val = registers[regidx(target)]
      if val > 0:
        ip += arg - 1

    ip += 1
    
type ProgramState = enum 
  Waiting, Terminated
    
type State = object
  ip: int
  registers: array[26, int]
  inbox: ref seq[int]
  outbox: ref seq[int]
  sentCnt: int
  state: ProgramState
  
proc execute(program: seq[string], state: var State): int =
  var executed = 0
  while true:
    if state.ip < 0 or state.ip >= program.len:
      state.state = Terminated
      return executed

    let instr = program[state.ip]
    let parts = instr.split

    let target = parts[1][0]
    let arg = if parts.len > 2: getarg(parts[2], state.registers) else: -1
    
    case parts[0]:
    of "snd":
      let arg = getarg(parts[1], state.registers)
      state.outbox[].add(arg)
      state.sentCnt += 1
    of "set":
      state.registers[regidx(target)] = arg
    of "add":
      state.registers[regidx(target)] += arg
    of "mul":
      state.registers[regidx(target)] *= arg
    of "mod":
      state.registers[regidx(target)] = state.registers[regidx(target)] mod arg
    of "rcv":
      if state.inbox[].len == 0:
        state.state = Waiting
        return executed
      let val = state.inbox[][0]
      state.inbox[].delete(0)
      state.registers[regidx(target)] = val
    of "jgz":
      let val = getarg(parts[1], state.registers)
      if val > 0:
        state.ip += arg - 1
        
    executed += 1
    state.ip += 1

proc part_two() =
  var inbox1 = new seq[int]
  var inbox2 = new seq[int]
  var states = [State(ip: 0, inbox: inbox1, outbox: inbox2, sentCnt: 0, state: Waiting), State(ip: 0, inbox: inbox2, outbox: inbox1, sentCnt: 0, state: Waiting)]
  states[0].registers[regidx('p')] = 0
  states[1].registers[regidx('p')] = 1

  var current = 0
  
  while true:
    if states[current].state == Waiting:
      let n = execute(program, states[current])
      if n == 0:
        break
        
    if states[0].state == Terminated and states[1].state == Terminated:
      break
    current = 1 - current
      
  echo(states[1].sentCnt)
    
  
part_two()