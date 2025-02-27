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

-- fully solved board condition: all lights are off
pred solved[b: Board] {
    all row, col: Int | {
        some l: Light | b.position[row][col] = l implies l.on = False
    }
    // all l: Light | l.on = False
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

-- defines toggling of a light: flips on/off and for neighbors
pred toggle[pre: Board, row, col: Int, post: Board] {

    -- ensure valid row, col being toggled
    row >= 0 
    row <= 2 
    col >= 0
    col <= 2
    
    -- check that there is a light at row, col 
    some l: Light | {

        pre.position[row][col] = l

    }

    -- maybe initially make the light on new board the same?
    // post.position[row][col] 

    -- then flip it and neighbors in post
    let oldLight = pre.position[row][col], newLight = post.position[row][col] | {
        // if l is on, then it is off on post
        // if l is off, then it is on on post
        oldLight.on = True implies newLight.on = False else newLight.on = True

        some l: Light | {

            oldLight.up = l
            l.on = True implies newLight.up.on = False else newLight.up.on = True
        } 
        some l: Light | {

            oldLight.down = l
            l.on = True implies newLight.down.on = False else newLight.down.on = True
        } 
        some l: Light | {

            oldLight.right = l
            l.on = True implies newLight.right.on = False else newLight.right.on = True
        } 
        some l: Light | {
            
            oldLight.left = l
            l.on = True implies newLight.left.on = False else newLight.left.on = True
        } 
    }

    //     (l.on = True) implies some l2: Light | {
    //         post.position[row][col] = l2
    //         l2.on = False
    //     }
    //     (l.on = False) implies some l2: Light | {
    //         post.position[row][col] = l2
    //         l2.on = True
    //     }
    // }


    -- other squares stay the same  ("frame condition")
    all row2: Int, col2: Int | (row!=row2 or col!=col2) implies {
        post.position[row2][col2] = pre.position[row2][col2]
    }
}

-- move
pred move[pre: Board, row, col: Int, post: Board]{
    row >= 0 and row <= 2
    col >= 0 and col <= 2
    -- Toggle the light and its neighbors
    toggle[pre, row, col, post]

}

-- impossible starting states??


pred gameTrace {
    -- Start with the initial state
    some last: Board | no Game.nextState[last]  -- Terminal state
    Game.initialState in Board  -- Initial board must exist
    all b: Board | some Game.nextState[b] => {
        some r, c: Int | move[b, r, c, Game.nextState[b]]
    }
    some b: Board | solved[b]  -- Solution must be reachable
}

pred noTrivialCycles {
    all b: Board | some Game.nextState[b] implies b != Game.nextState[b]
}


startingBoard: run {
    some b: Board | { 
        wellformed[b]
        init[b] 
    }
    gameTrace
} for exactly 1 Board, 9 Light, 4 Int



