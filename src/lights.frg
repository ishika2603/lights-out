#lang forge/froglet

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


-- defines toggling of a light: flips on/off and for neighbors
pred toggle[l: Light] {
    l.on' = !l.on
    all n: l.neighbors | n.on' = !n.on
}

-- fully solved board condition: all lights are off
pred solved[b: Board] {
    all row, col: Int | {
        b.position[row][col].on = False
    }
    // all l: Light | l.on = False
}




