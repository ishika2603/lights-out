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
    -- True if on, False if off (specific to Board state)
    on: pfunc Board -> Boolean,
    -- neighbors (lone because of border pieces, should be same across boards)
    up: lone Light,
    down: lone Light, 
    right: lone Light,
    left: lone Light
}

-- the board is essentially the State
-- Acts as a wrapper of a linkedlist to get to newer board states
sig Board {
    position: pfunc Int -> Int -> Light,
    next: lone Board
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
    all l: Light | {
        l.on[b] = False
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
    -- no two lights on the board are the same
    all l: Light | one row, col: Int | l = b.position[row][col]

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
        let l = b.position[row][col] | {
            some l => (l.on[b] = True or l.on[b] = False)
        }
    }

    -- ensure at least one light is on in the board
    some l: Light, row, col: Int | {
        l = b.position[row][col]
        l.on[b] = True
    }
}

-- helper predicate for finding neighbors or current light given row and cols
-- used in toggle[]
pred if_toggled[r, c, row, col: Int] {
    ((r = row and c = col) or
    (r = subtract[row, 1] and c = col) or
    (r = add[row, 1] and c = col) or
    (r = row and c = subtract[col, 1]) or
    (r = row and c = add[col, 1]))
}

-- defines toggling of a light: flips on/off and for neighbors
-- transitions from one board state to next
pred toggle[pre: Board, row, col: Int, post: Board] {

    -- ensure valid row, col being toggled
    within_bounds[row, col]

    -- check that there is a light at row, col 
    some pre.position[row][col]

    -- then flip it and neighbors in post
    -- For every cell (r,c) in the board (that has a light),
    -- copy the neighbor pointers and update the on state as required.
    all r, c: Int | some pre.position[r][c] implies {
        let oldL = pre.position[r][c], newL = post.position[r][c] | {
            newL.up = oldL.up
            newL.down = oldL.down
            newL.left = oldL.left
            newL.right = oldL.right

            -- If (r,c) is the toggled cell or a neighbor, then toggle the on state
            if_toggled[r, c, row, col] implies {
                ((oldL.on[pre] = True implies newL.on[post] = False) and
                (oldL.on[pre] = False implies newL.on[post] = True))
            }

            -- If (r,c) is not the toggled cell or a neighbor, then the on state remains same
            (not if_toggled[r, c, row, col] implies newL.on[post] = oldL.on[pre])
        }
    }
}
//making sure that the board is not refering to itself. 

pred allWellformed { all b: Board | wellformed[b]}

pred gameTrace {

    some firstBoard: Board | some lastBoard: Board | {
        -- Start with the initial state
        init[firstBoard]
        wellformed[firstBoard]
        
        no b: Board | b.next = firstBoard

        all b: Board | { some b.next implies {
            some row, col: Int | 
                toggle[b, row, col, b.next]
        }}

        -- terminal state
        no lastBoard.next
        solved[lastBoard]

    }

    allWellformed
    
}


//making sure that the max trace lengths is 30 

-- shows a valid starting board config
startingBoard: run {
    some b: Board | { 
        wellformed[b]
        init[b] 
    }
} for exactly 1 Board, 9 Light, 4 Int

//making sure that the max trace lengths is 30 
option max_tracelength 30
-- should show state that turns into solved board with one move
twoBoards: run {
    some b1, b2: Board | { 
        init[b1]
        wellformed[b1]
        toggle[b1, 1, 1, b2]
        wellformed[b2]
        solved[b2] 
        b1.next = b2
    }
    gameTrace
    //Having a randomly initialized board and try to trace whether there is final solution or not. 
    //as the b2 is the next of the b1, so b2 should contain the turn into a final state with all false
    //we successfully tested out the the result, it will truns all the lights to a false in the b2. 
    //
} for exactly 2 Board, 9 Light, 4 Int for {next is linear}

-- shows valid solved board config
solvedBoard: run {
    some b: Board | { 
        wellformed[b]
        solved[b] 
    }
} for exactly 1 Board, 9 Light, 4 Int for {next is linear}


traceBoards: run {gameTrace} for 5 Board, 9 Light, 4 Int for {next is linear}

-- takes bit less than minute usually
traceBoardslarge: run {gameTrace} for 10 Board, 9 Light, 4 Int for {next is linear}



