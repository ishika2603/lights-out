#lang forge/froglet

open "lights.frg"

test suite for validneighbors {

    // positive case: all correct neighbors
    example goodNeighbors is (all l: Light, b: Board | validneighbors[l, b]) for {
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
    
    // negative case: incorrect neighbor assigned
    example badNeighbors1 is (all b: Board | some l: Light | not validneighbors[l, b]) for {
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
        // incorrect neighbor
        `L00.down = `L11

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

}

pred lights_on_board[b: Board] {
    all l: Light | some row, col: Int | l = b.position[row][col]
}

test suite for wellformed {

    assert all b: Board | lights_on_board[b] is necessary for wellformed[b]

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

    // positive case: all lights are off
    example winningboard is (all b: Board | solved[b]) for {
        Board = `Board0
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22

        Boolean = `True + `False
        True = `True
        False = `False

        `L00.on = `Board0 -> `False
        `L10.on = `Board0 -> `False
        `L20.on = `Board0 -> `False
        `L11.on = `Board0 -> `False
        `L12.on = `Board0 -> `False
        `L22.on = `Board0 -> `False
        `L01.on = `Board0 -> `False
        `L02.on = `Board0 -> `False
        `L21.on = `Board0 -> `False
    }

    // positive case: all lights off, but attached to 2 diff boards (shouldnt make a difference)
    // one is solved, one isnt
    example anotherwinningboard is (some b: Board | solved[b]) for {
        Game = `Game0
        Board = `Board0 + `Board1
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22

        Boolean = `True + `False
        True = `True
        False = `False

        `Game0.first = `Board0
        `Game0.next = `Board0 -> `Board1

        `Board0.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22
        `Board1.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.on = `Board0 -> `True + `Board1 -> `False
        `L10.on = `Board0 -> `False + `Board1 -> `False
        `L20.on = `Board0 -> `False + `Board1 -> `False
        `L11.on = `Board0 -> `False + `Board1 -> `False
        `L12.on = `Board0 -> `True + `Board1 -> `False
        `L22.on = `Board0 -> `True + `Board1 -> `False
        `L01.on = `Board0 -> `False + `Board1 -> `False
        `L02.on = `Board0 -> `True + `Board1 -> `False
        `L21.on = `Board0 -> `True + `Board1 -> `False
    }

    // negative case: no board is solved
    example losingboard is (all b: Board | not solved[b]) for {
                Game = `Game0
        Board = `Board0 + `Board1
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22

        Boolean = `True + `False
        True = `True
        False = `False

        `Game0.first = `Board0
        `Game0.next = `Board0 -> `Board1

        `Board0.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22
        `Board1.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.on = `Board0 -> `True + `Board1 -> `False
        `L10.on = `Board0 -> `False + `Board1 -> `False
        `L20.on = `Board0 -> `False + `Board1 -> `False
        `L11.on = `Board0 -> `False + `Board1 -> `False
        `L12.on = `Board0 -> `True + `Board1 -> `False
        `L22.on = `Board0 -> `True + `Board1 -> `False
        `L01.on = `Board0 -> `False + `Board1 -> `False
        `L02.on = `Board0 -> `True + `Board1 -> `False
        `L21.on = `Board0 -> `True + `Board1 -> `True
    }
}

test suite for init {

    // positive case: board with at least one light on
    example validInit is {all b: Board | init[b] } for {
        Game = `Game0
        Board = `Board0
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False

        `Game0.first = `Board0

        `Board0.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.on = `Board0 -> `False
        `L10.on = `Board0 -> `False
        `L20.on = `Board0 -> `False
        `L11.on = `Board0 -> `False
        `L12.on = `Board0 -> `False
        `L22.on = `Board0 -> `False
        `L01.on = `Board0 -> `True
        `L02.on = `Board0 -> `False
        `L21.on = `Board0 -> `False
    }

    // negative case: all lights off
    example invalidInit is {all b: Board | not init[b] } for {
        Game = `Game0
        Board = `Board0
        Light = `L00 + `L01 + `L02 +
                `L10 + `L11 + `L12 +
                `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False

        `Game0.first = `Board0

        `Board0.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.on = `Board0 -> `False
        `L10.on = `Board0 -> `False
        `L20.on = `Board0 -> `False
        `L11.on = `Board0 -> `False
        `L12.on = `Board0 -> `False
        `L22.on = `Board0 -> `False
        `L01.on = `Board0 -> `False
        `L02.on = `Board0 -> `False
        `L21.on = `Board0 -> `False
    }

}

test suite for toggle {

    // Positive case: toggling the center cell (1,1) flips its state and that of its neighbors.
    example validToggleCenter is {some pre, post: Board | toggle[pre, 1, 1, post] } for {
        Board = `PreBoard + `PostBoard
        Light = `L00 + `L01 + `L02 +
                    `L10 + `L11 + `L12 +
                    `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False

        `PreBoard.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `PostBoard.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.right = `L01
        `L00.down  = `L10

        `L01.left  = `L00
        `L01.right = `L02
        `L01.down  = `L11

        `L02.left  = `L01
        `L02.down  = `L12

        `L10.up    = `L00
        `L10.right = `L11
        `L10.down  = `L20

        `L11.up    = `L01
        `L11.left  = `L10
        `L11.right = `L12
        `L11.down  = `L21

        `L12.up    = `L02
        `L12.left  = `L11
        `L12.down  = `L22

        `L20.up    = `L10
        `L20.right = `L21

        `L21.up    = `L11
        `L21.left  = `L20
        `L21.right = `L22

        `L22.up    = `L12
        `L22.left  = `L21

        // Row 0:
        `L00.on = `PreBoard -> `True + `PostBoard -> `True
        `L01.on = `PreBoard -> `False + `PostBoard -> `True
        `L02.on = `PreBoard -> `True + `PostBoard -> `True
        // Row 1:
        `L10.on = `PreBoard -> `False + `PostBoard -> `True
        `L11.on = `PreBoard -> `True + `PostBoard -> `False  // cell (1,1) toggled
        `L12.on = `PreBoard -> `False + `PostBoard -> `True
        // Row 2:
        `L20.on = `PreBoard -> `True + `PostBoard -> `True
        `L21.on = `PreBoard -> `False + `PostBoard -> `True
        `L22.on = `PreBoard -> `True + `PostBoard -> `True
        }

    // Positive case: toggling the side cell (2,1) flips its state and that of its neighbors.
    example validToggleSide is {some pre, post: Board | toggle[pre, 2, 1, post] } for {
        Board = `PreBoard + `PostBoard
        Light = `L00 + `L01 + `L02 +
                    `L10 + `L11 + `L12 +
                    `L20 + `L21 + `L22
        Boolean = `True + `False
        True = `True
        False = `False

        `PreBoard.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `PostBoard.position =
            (0,0) -> `L00 + (0,1) -> `L01 + (0,2) -> `L02 +
            (1,0) -> `L10 + (1,1) -> `L11 + (1,2) -> `L12 +
            (2,0) -> `L20 + (2,1) -> `L21 + (2,2) -> `L22

        `L00.right = `L01
        `L00.down  = `L10

        `L01.left  = `L00
        `L01.right = `L02
        `L01.down  = `L11

        `L02.left  = `L01
        `L02.down  = `L12

        `L10.up    = `L00
        `L10.right = `L11
        `L10.down  = `L20

        `L11.up    = `L01
        `L11.left  = `L10
        `L11.right = `L12
        `L11.down  = `L21

        `L12.up    = `L02
        `L12.left  = `L11
        `L12.down  = `L22

        `L20.up    = `L10
        `L20.right = `L21

        `L21.up    = `L11
        `L21.left  = `L20
        `L21.right = `L22

        `L22.up    = `L12
        `L22.left  = `L21

        // Row 0:
        `L00.on = `PreBoard -> `False + `PostBoard -> `False
        `L01.on = `PreBoard -> `False + `PostBoard -> `False
        `L02.on = `PreBoard -> `False + `PostBoard -> `False
        // Row 1:
        `L10.on = `PreBoard -> `False + `PostBoard -> `False
        `L11.on = `PreBoard -> `True + `PostBoard -> `False  
        `L12.on = `PreBoard -> `False + `PostBoard -> `False
        // Row 2:
        `L20.on = `PreBoard -> `True + `PostBoard -> `False
        `L21.on = `PreBoard -> `True + `PostBoard -> `False // cell (2,1) toggled
        `L22.on = `PreBoard -> `False + `PostBoard -> `True
        }

}



