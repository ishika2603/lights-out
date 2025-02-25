// -------------------- CONSTANTS --------------------------

const CELL_SIZE = 100
const BOARD_DIM = 3


// --------------- BOARD CREATION FUNCTIONS ----------------

/**
 * creates grid for board
 * @param {number} cell_size 
 * @param {number} dim
 * @returns Grid object
 */
function create_grid(cell_size, dim) {
  return new Grid({
    grid_location: {x: 100, y:100},
    cell_size: {x_size: cell_size, y_size: cell_size},
    grid_dimensions: {x_size: dim, y_size: dim}
  })
}

// Helper: return a boolean for a Light atom's state
function getLightState(lightAtom) {
  // Assume lightAtom.toString() returns something like "Light$True" or "Light$False"
  return lightAtom.toString().includes("True");
}



// ------------------- VISUALIZATION -----------------------

let grid = create_grid(CELL_SIZE, BOARD_DIM)
grid.add({x: 0, y: 1}, new Circle({radius: 10, color: "red"}))
grid.add({x: 2, y: 2}, new Circle({radius: 10, color: "blue"}))

const stage = new Stage()
stage.add(new TextBox({
text: 'Lights Out!', 
coords: {x:250, y:50},
color: 'black',
fontSize: 20
}))
stage.add(grid)


stage.render(svg, document)
