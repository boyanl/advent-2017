
func total_score(line: string): int =
  var level = 0
  var inside_garbage = false
  var escape_next = false
  var total = 0

  for c in line:
    if inside_garbage:
      if escape_next:
        escape_next = false
      elif c == '!':
        escape_next = true
      elif c == '>':
        inside_garbage = false
    else:
      if c == '{':
        level += 1
      elif c == '}':
        total += level
        level -= 1
      elif c == '<':
        inside_garbage = true

  total
  
func count_removed_garbage(line: string): int = 
  var inside_garbage = false
  var escape_next = false
  var total = 0

  for c in line:
    if inside_garbage:
      if escape_next:
        escape_next = false
      elif c == '!':
        escape_next = true
      elif c == '>':
        inside_garbage = false
      else:
        total += 1
    else:
      if c == '<':
        inside_garbage = true

  total

proc part_one() =
  for line in stdin.lines:
    let score = total_score(line)
    echo(score)
    
proc part_two() = 
  for line in stdin.lines:
    let removed_garbage = count_removed_garbage(line)
    echo(removed_garbage)

part_two()