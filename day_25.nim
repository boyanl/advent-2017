import tables
import strscans
import strformat

type Transition = object
  current_val: int
  new_val: int
  pos_delta: int
  new_state: char

type TuringMachine = Table[char, seq[Transition]]
type Tape = Table[int, int]

proc read_transitions(): seq[Transition] =
  for line in stdin.lines:
    var current_val: int
    if scanf(line, "$sIf the current value is $i:", current_val):
      let write_instr = stdin.readLine
      var to_write: int
      discard scanf(write_instr, "$s- Write the value $i.", to_write)

      let move_instr = stdin.readLine
      var direction: string
      discard scanf(move_instr, "$s- Move one slot to the $*.", direction)
      var delta = if direction == "right": 1 else: -1

      let continue_instr = stdin.readLine
      var next_state: char
      discard scanf(continue_instr, "$s- Continue with state $c.", next_state)
      
      result.add(Transition(current_val: current_val, new_val: to_write, pos_delta: delta, new_state: next_state))
    else:
      break
    

proc simulate_machine(machine: TuringMachine, start_state: char, steps: int): Tape =
  var state = start_state
  var cursor = 0
  for r in 1..steps:
    if not result.hasKey(cursor):
      result[cursor] = 0
    for transition in machine[state]:
      if result[cursor] == transition.current_val:
        result[cursor] = transition.new_val
        cursor += transition.pos_delta
        state = transition.new_state
        break
        
        
func checksum(t: Tape): int =
  for k, v in t:
    if v == 1:
      result += 1

proc read_turing_machine(): TuringMachine =
  var machine = initTable[char, seq[Transition]]()
  for line in stdin.lines:
    var state_name: char
    if scanf(line, "$sIn state $c:", state_name):
      let transitions = read_transitions() 
      machine[state_name] = transitions

  return machine

proc read_input(): (TuringMachine, char, int) =
  var start_state: char
  discard scanf(stdin.readLine, "Begin in state $c.", start_state)
  
  var steps: int
  discard scanf(stdin.readLine, "Perform a diagnostic checksum after $i steps.", steps)
  
  return (read_turing_machine(), start_state, steps)


let (machine, start_state, steps) = read_input()
let result = checksum(simulate_machine(machine, start_state, steps))
echo(result)