#lang forge/froglet

open "lights.frg"

test suite for validneighbors {

}

test suite for wellformed {

    // positive case: a valid 3×3 board with correct neighbor assignments.
    example validWellformedBoard is {all b: Board | wellformed[b] } for {
        Board = `Board0
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False

        `Board0.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.right = `L01
        `L00.down = `L10

        `L01.left = `L00
        `L01.right = `L02
        `L01.down = `L11

        `L02.left = `L01
        `L02.down = `L12

        `L10.up = `L00
        `L10.right = `L11
        `L10.down  = `L20

        `L11.up = `L01
        `L11.left = `L10
        `L11.right = `L12
        `L11.down = `L21

        `L12.up = `L02
        `L12.left = `L11
        `L12.down = `L22

        `L20.up = `L10
        `L20.right = `L21

        `L21.up = `L11
        `L21.left = `L20
        `L21.right = `L22

        `L22.up = `L12
        `L22.left = `L21
    }

    // negative case: incorrect neighbors
    example invalidWellformedBoard is {all b: Board | not wellformed[b] } for {
        Board = `Board0
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False

        `Board0.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        // should be `L00.right = `L01, but `L02 is wrong neighbor
        `L00.right = `L02

        `L00.down = `L10

        `L01.left = `L00
        `L01.right = `L02
        `L01.down = `L11

        `L02.left = `L01
        `L02.down = `L12

        `L10.up = `L00
        `L10.right = `L11
        `L10.down = `L20

        `L11.up = `L01
        `L11.left = `L10
        `L11.right = `L12
        `L11.down = `L21

        `L12.up = `L02
        `L12.left = `L11
        `L12.down = `L22

        `L20.up = `L10
        `L20.right = `L21

        `L21.up = `L11
        `L21.left = `L20
        `L21.right = `L22

        `L22.up = `L12
        `L22.left = `L21
    }

    // negative case: all lights not on board
    example invalidWellformedBoard2 is {all b: Board | not wellformed[b] } for {
        Board = `Board0
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False
        
        // L00 missing at 0, 0
        `Board0.position =
            (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.right = `L01
        `L00.down = `L10

        `L01.left = `L00
        `L01.right = `L02
        `L01.down = `L11

        `L02.left = `L01
        `L02.down = `L12

        `L10.up = `L00
        `L10.right = `L11
        `L10.down = `L20

        `L11.up = `L01
        `L11.left = `L10
        `L11.right = `L12
        `L11.down = `L21

        `L12.up = `L02
        `L12.left = `L11
        `L12.down = `L22

        `L20.up = `L10
        `L20.right = `L21

        `L21.up = `L11
        `L21.left = `L20
        `L21.right = `L22

        `L22.up = `L12
        `L22.left = `L21
    }

}

test suite for solved {


}

test suite for init {


}

test suite for toggle {


}



