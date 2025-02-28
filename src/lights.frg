#lang forge/froglet

-- run visualization
option run_sterling "vis.js"

-------------------
-- Puzzle Structure
-------------------
abstract sig Boolean {}
one sig True, False extends Boolean {}

-- defines a light square, and its neighbors
sig Light {
    -- True if on, False if off
    on: pfunc Board -> Boolean,
    -- neighbors (lone because of border pieces)
    up: lone Light,
    down: lone Light, 
    right: lone Light,
    left: lone Light
}

-- the board is essentially the State
sig Board {
    position: pfunc Int -> Int -> Light
}

-- holds the initial board state and then acts as a wrapper of a 
-- linkedlist to get to newer board states
one sig Game {
    first: one Board,
    next: pfunc Board -> Board
}

-- defines bounds of 3x3 board
pred within_bounds[row, col: Int] {
    row >= 0 
    row <= 2 
    col >= 0
    col <= 2
}

-- fully solved board condition: all lights are off
pred solved[b: Board] {
    // all l: Light | l.on = False
    all row, col: Int | {
        // some l: Light | b.position[row][col] = l implies l.on = False
        within_bounds[row, col] implies (b.position[row][col]).on[b] = False
    }
}

-- define valid neighbors
// (used within wellformed, helper predicate)
pred validneighbors[l: Light, b: Board] {
    some row, col: Int | {
        l = b.position[row][col]
        -- check up
        (row > 0) implies (some lu: Light | b.position[subtract[row, 1]][col] = lu and l.up = lu) else no l.up 
        -- check down
        (row < 2) implies (some ld: Light | b.position[add[row, 1]][col] = ld and l.down = ld) else no l.down
        -- check right
        (col < 2) implies (some lr: Light | b.position[row][add[col, 1]] = lr and l.right = lr) else no l.right
        -- check left
        (col > 0) implies (some ll: Light | b.position[row][subtract[col, 1]] = ll and l.left = ll) else no l.left
    }
}

-- wellformed board
pred wellformed[b: Board] {

    all row, col: Int | {
        -- within bounds
        -- every piece on board has a light
        within_bounds[row, col] implies {
            some b.position[row][col]
        } else no b.position[row][col]

    }

    -- all lights must be on the board
    all l: Light | some row, col: Int | l = b.position[row][col]

    -- no two lights on the board are the same
    all row1, col1, row2, col2: Int | {
        (some b.position[row1][col1] and some b.position[row2][col2] and (row1 != row2 or col1 != col2)) implies {
            b.position[row1][col1] != b.position[row2][col2]
        }
    }

    -- ensure all lights have valid neighbors
    all l: Light | {
        validneighbors[l, b]
    }
}

-- init (starting)
pred init[b: Board]{
    -- generate a starting board
    -- Randomly set each light ON or OFF
    all row, col: Int | {
        some b.position[row][col] => {
            some l: Light | {
                l = b.position[row][col]
                some l.on[b]
            }
        }
    }

    -- ensure at least one light is on in the board
    some l: Light, row, col: Int | {
        l = b.position[row][col]
        l.on[b] = True
    }
}

// -- defines toggling of a light: flips on/off and for neighbors
// -- transitions from one board state to next
// pred toggle[pre: Board, row, col: Int, post: Board] {

//     -- ensure valid row, col being toggled
//     row >= 0 
//     row <= 2 
//     col >= 0
//     col <= 2
    
//     -- check that there is a light at row, col 
//     some l: Light | {
//         pre.position[row][col] = l
//     }

//     -- then flip it and neighbors in post
//     let oldLight = pre.position[row][col], newLight = post.position[row][col] | {
//         // if l is on, then it is off on post
//         // if l is off, then it is on on post
//         oldLight.on = True implies newLight.on = False else newLight.on = True

//         some l: Light | {
//             oldLight.up = l
//             l.on = True implies newLight.up.on = False else newLight.up.on = True
//         } 
//         some l: Light | {
//             oldLight.down = l
//             l.on = True implies newLight.down.on = False else newLight.down.on = True
//         } 
//         some l: Light | {
//             oldLight.right = l
//             l.on = True implies newLight.right.on = False else newLight.right.on = True
//         } 
//         some l: Light | {
//             oldLight.left = l
//             l.on = True implies newLight.left.on = False else newLight.left.on = True
//         } 
//     }

//     -- other squares stay the same  ("frame condition")
//     all row2: Int, col2: Int | (row!=row2 or col!=col2) implies {
//         post.position[row2][col2] = pre.position[row2][col2]
//     }
// }

// -- defines toggling of a light: flips on/off and for neighbors
// -- transitions from one board state to next
// pred toggle[pre: Board, row, col: Int, post: Board] {

//     -- ensure valid row, col being toggled
//     within_bounds[row, col]

//     -- check that there is a light at row, col 
//     some pre.position[row][col]

//     -- For every cell (r,c) in the board (that has a light), copy the neighbor pointers and update the on state as required.
//     all r, c: Int | some pre.position[r][c] implies {
//         let oldL = pre.position[r][c],
//             newL = post.position[r][c] |
//         newL.up    = oldL.up    and
//         newL.down  = oldL.down  and
//         newL.left  = oldL.left  and
//         newL.right = oldL.right and

//         -- If (r,c) is the toggled cell or a neighbor, then toggle the on state:
//         (((r = row and c = col) or
//           (r = subtract[row, 1] and c = col) or
//           (r = add[row, 1] and c = col) or
//           (r = row and c = subtract[col, 1]) or
//           (r = row and c = add[col, 1]))
//           implies 
//              ((oldL.on = True implies newL.on = False) and
//               (oldL.on = False implies newL.on = True)))
//         and
//         -- If (r,c) is not the toggled cell or a neighbor, then the on state remains unchanged:
//         ((not ((r = row and c = col) or
//                (r = subtract[row, 1] and c = col) or
//                (r = add[row, 1] and c = col) or
//                (r = row and c = subtract[col, 1]) or
//                (r = row and c = add[col, 1])))
//           implies newL.on = oldL.on)
//     }
// }


pred allWellformed { all b: Board | wellformed[b]}

pred gameTrace {
    // -- Start with the initial state
    some last: Board | no Game.next[last]  -- Terminal state

    init[Game.first]
    wellformed[Game.first]
    
    // all b: Board | { some Game.next[b] implies {
    //     some row, col: Int | 
    //         // toggle[b, row, col, Game.next[b]]
    // }}

    // some b: Board | solved[b]

}

pred noTrivialCycles {
    all b: Board | some Game.next[b] implies b != Game.next[b]
}

startingBoard: run {
    some b: Board | { 
        wellformed[b]
        init[b] 
    }
} for exactly 1 Board, 9 Light, 4 Int

twoBoards: run {
    some b1, b2: Board | { 
        init[b1]
        wellformed[b1]
        // toggle??
        wellformed[b2]
        solved[b2] 
    }
} for exactly 2 Board, 9 Light, 4 Int

solvedBoard: run {
    some b: Board | { 
        wellformed[b]
        solved[b] 
    }
} for exactly 1 Board, 9 Light, 4 Int


traceBoards: run {gameTrace} for 2 Board, 9 Light, 4 Int for {next is linear}



