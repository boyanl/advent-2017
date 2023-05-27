import strscans
import strutils
import sequtils
import tables
import sugar

type Node = ref object
    name: string
    weight: int
    parent: Node
    children: seq[Node]
    
proc parse_input(): Node =
    var nodes_raw: seq[(string, int, seq[string])] = @[]
    for line in stdin.lines:
        var name: string
        var weight: int
        var child_names_str: string
        if scanf(line, "$w ($i) -> $+", name, weight, child_names_str):
            let child_names = child_names_str.strip.split(", ")
            nodes_raw.add((name, weight, child_names))
        elif scanf(line, "$w ($i)", name, weight):
            nodes_raw.add((name, weight, @[]))
            
    var nodes: seq[Node] = @[]
    var name_to_node = initTable[string, Node]()
    for (name, weight, _) in nodes_raw:
        let node = Node(name: name, weight: weight, parent: nil, children: @[])
        nodes.add(node)
        name_to_node[name] = node
        
    for i, (_, _, child_names) in nodes_raw.pairs:
        for child_name in child_names:
            let child_node = name_to_node[child_name]
            nodes[i].children.add(child_node)
            child_node.parent = nodes[i]
        
    for node in nodes:
        if node.parent == nil:
            return node
    return nil
    

let root = parse_input()

proc part_one() =
   echo(root.name)
   
func total_weight(root: Node): int =
    var total = 0
    for node in root.children:
        total += total_weight(node)
        
    return root.weight + total
    
func most_frequent(ns: seq[int]): int =
    var cnts = initTable[int, int]()
    for n in ns:
        if not cnts.hasKey(n):
            cnts[n] = 0
        cnts[n] += 1
        
    var res = 0
    var maxcnt = -1
    
    for n, cnt in cnts:
        if cnt > maxcnt:
            res = n
            maxcnt = cnt

    res
    
func find_unbalanced_disk(root: Node, delta: int): (Node, int, int) =
    let weights = root.children.map(x => total_weight(x))
    let expected = most_frequent(weights)
    let same = weights.all(x => x == expected)
    
    if same:
        return (root, root.weight, root.weight + delta)
    else:
        for (i, w) in weights.pairs:
            if w != expected:
                assert(expected - w == delta)
                return find_unbalanced_disk(root.children[i], delta)
         
        
    
   
func find_unbalanced_disk(root: Node): (Node, int, int) =
    let weights = root.children.map(x => total_weight(x))
    let expected = most_frequent(weights)
    let same = weights.all(x => x == expected)
    if not same:
        for (i, w) in weights.pairs:
            if w != expected:
                let delta = expected - w
                return find_unbalanced_disk(root.children[i], delta)
    
    return (nil, 0, 0)
    
   
proc part_two() =
    let (_, _, expected_weight) = find_unbalanced_disk(root)
    echo(expected_weight)
    

part_two()