import strutils
import sequtils
import math

proc regidx(regName: char): int =
  ord(regName) - ord('a')

proc getarg(arg: string, registers: openArray[int]): int =
  if arg[0].isLowerAscii:
    return registers[regidx(arg[0])]
  return arg.parseInt

type State = object
  ip: int
  registers: array[8, int]
  
proc execute(program: seq[string], state: var State, instr_limit: int = -1): int =
  var executed = 0
  var mulCnt = 0
  while true:
    if instr_limit > 0 and executed > instr_limit:
      return mulCnt
    if state.ip < 0 or state.ip >= program.len:
      return mulCnt

    let instr = program[state.ip]
    let parts = instr.split

    let target = parts[1][0]
    let arg = if parts.len > 2: getarg(parts[2], state.registers) else: -1
    
    case parts[0]:
    of "set":
      state.registers[regidx(target)] = arg
    of "add":
      state.registers[regidx(target)] += arg
    of "sub":
      state.registers[regidx(target)] -= arg
    of "mul":
      mulCnt += 1
      state.registers[regidx(target)] *= arg
    of "mod":
      state.registers[regidx(target)] = state.registers[regidx(target)] mod arg
    of "jgz":
      let val = getarg(parts[1], state.registers)
      if val > 0:
        state.ip += arg - 1
    of "jnz":
      let val = getarg(parts[1], state.registers)
      if val != 0:
        state.ip += arg - 1
    else:
      echo("Unknown instruction: ", parts[0])
        
    echo(state.registers)
    executed += 1
    state.ip += 1
    
let program = stdin.lines.toSeq

proc part_one() = 
  var state = State(ip: 0)
  let result = execute(program, state)
  echo(result)
  

func program_translated_1(): int =
  var a = 1
  var b = 67
  var c = b
  if a != 0:
    b *= 100
    b -= -100000
    c = b
    c -= -17000
  
  var d: int
  var e: int
  var f: int
  var h: int
  while true:
    f = 1
    d = 2
    while true:
      e = 2
      while true:
        if d * e == b:
          f = 0
        e += 1
        if e == b:
          break
      d += 1
      if d == b:
        break
    if f == 0:
      h += 1
    if b == c:
      break
    b += 17

  return h

func is_prime(b: int): bool =
  if b mod 2 == 0:
    return false
  for d1 in countup(3, int(float(b).sqrt)):
    if b mod d1 == 0:
      return false
  return true

func program_actually_translated_and_optimized(): int =
  var primes_cnt = 0
  for b in countup(106700, 123700, 17):
    primes_cnt += (if is_prime(b): 0 else: 1)
    
  return primes_cnt
    
proc part_two() = 
  let result = program_actually_translated_and_optimized()
  echo(result)
  
part_two()