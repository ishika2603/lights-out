abstract sig Boolean {}
one sig True, False extends Boolean {}

sig Light {
    on: one Boolean
}

sig Board {
    position: pfunc Int -> Int -> Light
}

one sig Game {
    initialState: Board,
    nextState: pfunc Board -> Board
}

-- Grid constraints
fact gridBounds {
    all b: Board | all x, y: Int | 
        (x < 0 or x > 2 or y < 0 or y > 2) implies no b.position[x][y]
}

fact completeGrid {
    all b: Board | all x, y: Int | 
        (x >= 0 and x <= 2 and y >= 0 and y <= 2) implies one b.position[x][y]
}

pred neighbors[x, y: Int] {
    result = {x': Int, y': Int | 
        (x' = x-1 and y' = y) or 
        (x' = x+1 and y' = y) or 
        (x' = x and y' = y-1) or 
        (x' = x and y' = y+1)}
}

pred press[b, b': Board, x, y: Int] {
    -- Legal coordinates
    x >= 0 and x <= 2
    y >= 0 and y <= 2
    
    -- Find light at position
    some l: Light | l = b.position[x][y]
    
    -- Toggle pressed light and neighbors
    all nx, ny: Int | 
        (nx = x and ny = y) or neighbors[x,y][nx,ny] implies {
            some l: Light | l = b.position[nx][ny] and l.on' = not l.on
        }
    
    -- Preserve other lights
    all nx, ny: Int | 
        not ((nx = x and ny = y) or neighbors[x,y][nx,ny]) implies {
            some l: Light | l = b.position[nx][ny] and l.on' = l.on
        }
}

pred init {
    -- All lights start on
    all l: Light | l.on = True
    
    -- Initialize board positions
    all x: 0..2, y: 0..2 | one l: Light | Game.initialState.position[x][y] = l
}

pred solved {
    -- All lights off
    all l: Light | l.on = False
}

-- Find a solution sequence
run {
    init
    eventually solved
    always {
        -- Only move through valid presses
        all b: Board - Game.initialState | some prev: Board | Game.nextState[prev] = b
        all b: Board | some x,y: Int | press[b, Game.nextState[b], x, y]
    }
} for 5 Board, 9 Light, 3 Int

