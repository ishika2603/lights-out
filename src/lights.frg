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
    on: one Boolean,
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
    initialState: one Board,
    nextState: pfunc Board -> Board
}

-- defines toggling of a light: flips on/off and for neighbors
pred toggle[pre: Board, row, col: Int, post: Board] {

    -- ensure valid row, col being toggled
    row >= 0 
    row <= 2 
    col >= 0
    col <= 2
    
    -- check that there is a light at row, col 
    -- then flip it and neighbors in post,
    some l: Light | {
        pre.position[row][col] = l
        
        // if l is on, then it is off on post
        // if l is off, then it is on on post
        (l.on = True) implies some l2: Light | {
            post.position[row][col] = l2
            l2.on = False
        }
        (l.on = False) implies some l2: Light | {
            post.position[row][col] = l2
            l2.on = True
        }
    }

    -- other squares stay the same  ("frame condition")
    all row2: Int, col2: Int | (row!=row2 or col!=col2) implies {
        post.position[row2][col2] = pre.position[row2][col2]
    }
    // l.on = not l.on
    // all n: l.neighbors | n.on' = not n.on
}

-- fully solved board condition: all lights are off
pred solved[b: Board] {
    all row, col: Int | {
        some l: Light | b.position[row][col] = l => l.on = False
    }
    // all l: Light | l.on = False
}

-- define valid neighbors
// pred neighbors[l: Light, b: Board] {
//     all row, col: Int | {
//         (l in b.position[row][col]) implies {
//             -- list possible neighbors based on row/col position
//             let neighborsSet = set {
//                 -- Check up
//                 if row > 0 then some b.position[subtract[]][col] else no,
//                 -- Check down
//                 if row < 2 then some b.position[add[row,1]][col] else no,
//                 -- Check left
//                 if col > 0 then some b.position[row][subtract[col-1]] else no,
//                 -- Check right
//                 if col < 2 then some b.position[row][add[col,1]] else no
//             }
//             -- ensure the neighbors list is valid
//             l.neighbors = neighborsSet
//         }
//     }
// }

-- wellformed board
pred wellformed[b: Board] {

    all row, col: Int | {
        -- within bounds
        -- every piece on board has a light
        (row >= 0 and row <= 2 and col >= 0 and col <= 2) implies {
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

    // all l: Light | {
    //     -- Neighbors must be within valid range
    //     all n: l.neighbors | some row, col: Int | {
    //         (row >= 0 and row <= 2 and col >= 0 and col <= 2)
    //         n = b.position[row][col]
    //     }

    //     -- TODO: define valid neighbors
    //     // neighbors[l, b]

    // }
}

-- init (starting)
pred init[b: Board]{
    -- generate a starting board
    -- Randomly set each light ON or OFF
    all row, col: Int | {
        some b.position[row][col] => {
            some l: Light | {
                l = b.position[row][col]
                l.on in Boolean
            }
        }
    }

    -- ensure at least on light is on in the board
    some l: Light, row, col: Int | {
        l = b.position[row][col]
        l.on = True
    }
}



-- move
pred move[pre: Board, r, c: Int, post: Board]{
    -- GUARD


    -- ACTION


    -- FRAMING

}




pred gameTrace {

}

startingBoard: run {
    some b: Board | { 
        wellformed[b]
        init[b] 
    }
} for exactly 1 Board, 9 Light, 4 Int



