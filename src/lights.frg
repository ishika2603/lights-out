#lang forge/froglet

-- run visualization
// option run_sterling "vis.js"

-- define all objects
abstract sig Boolean {}
one sig True, False extends Boolean {}

sig Light {
    on: one Boolean,
    neighbors: set Light
}

sig Board {
    position: pfunc Int -> Int -> Light
}

one sig Game {
    initialState: one Board,
    nextState: pfunc Board -> Board
}

-- defines toggling of a light: flips on/off and for neighbors
pred toggle[l: Light] {
    l.on' = not l.on
    all n: l.neighbors | n.on' = not n.on
}

-- fully solved board condition: all lights are off
pred solved[b: Board] {
    all row, col: Int | {
        b.position[row][col].on = False
    }
    // all l: Light | l.on = False
}

-- wellformed board
pred wellformed[b: Board] {

    -- within bounds
    -- every piece on board has a light
    

}


-- move
pred move[pre: Board, r, c: Int, post: Board]{
    -- GUARD


    -- ACTION


    -- FRAMING

}


-- init (starting)
pred init[]{

    -- generate a starting board

}


pred traces {

}





