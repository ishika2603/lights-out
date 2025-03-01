// -------------------- CONSTANTS --------------------------

const GRID_ROWS = 3;  
const GRID_COLS = 3;        
const CELL_SIZE = 100;       
const GRID_MARGIN = 20;   
const GRID_Y = 100;
const GRID_X = 100;

const LIGHT_ON_COLOR = "#FFD700"; // Yellow when light is on
const LIGHT_OFF_COLOR = "#333333"; // Dark gray when light is off
const CELL_BORDER_COLOR = "black";
const CELL_BORDER_WIDTH = 3;

const SVG_WIDTH = GRID_COLS * CELL_SIZE + 2 * GRID_MARGIN;
const SVG_HEIGHT = GRID_ROWS * CELL_SIZE + 2 * GRID_MARGIN;

const BUTTONS = ['PREV', 'NEXT'];
// TODO
// const BUTTON_WIDTH = SVG_WIDTH / BUTTONS.length * 0.9;
// const BUTTON_HEIGHT = (SCREEN_HEIGHT - GRAPH_HEIGHT) * 0.7;
// const BUTTON_SPACING = SCREEN_WIDTH / (BUTTONS.length + 1) * 0.1;
// const BUTTON_Y = GRAPH_HEIGHT;
// const BUTTON_XS = BUTTONS.map((_, idx) =>
//     BUTTON_SPACING + idx * (BUTTON_WIDTH + BUTTON_SPACING)
// );

// const BUTTON_TEXT_Y = BUTTON_Y + BUTTON_HEIGHT / 2;
// const BUTTON_TEXT_XS = BUTTON_XS.map(x => x + BUTTON_WIDTH / 2);


const svgContainer = document.getElementById('svg-container');
svgContainer.getElementsByTagName('svg')[0].style.height = `${SVG_HEIGHT}px`;
svgContainer.getElementsByTagName('svg')[0].style.width = `${SVG_WIDTH}px`;

// -------------------- HELPER/FORGE FUNCTIONS --------------

/**
 * Given a Forge Boolean atom, returns the corresponding fill color.
 * Assumes the atoms have id "True" or "False".
 */
function getFillColor(bo) {
  return bo.id() === "True0" ? LIGHT_ON_COLOR : LIGHT_OFF_COLOR;
}

// // Helper: return a boolean for a Light atom's state
// function getLightState(lightAtom) {
//   // Assume lightAtom.toString() returns something like "Light$True" or "Light$False"
//   return lightAtom.toString().includes("True");
// }

/**
 * @returns {number} Number of boards in the instance
 */
function get_how_many_boards() {
  return instance.signature('Board').atoms().length;
}

/**
 * @returns {number} Number of lights in the instance
 * (should be 9 always)
 */
function get_how_many_lights() {
  return instance.signature('Light').atoms().length;
}

/**
 * Converts the name of an object in forge to the index of the object
 * @param {string} forge_obj_str Name of the object in the forge
 * @returns {number} Index of the object in the forge
 */
function get_index(forge_obj_str) {
  return parseInt(forge_obj_str.slice(-1));
}

/**
 * Retrieves the board from the instance.
 */
function getStartingBoard() {
  // Assume instance.signature('Board').atoms() returns an array of board atoms.
  return instance.signature('Board').atoms()[0];
}


// --------------- BOARD CREATION FUNCTIONS ----------------

/**
 * creates grid for board
 * @param {number} cell_size 
 * @param {number} dim
 * @returns Grid object
 */
function create_grid() {
  return new Grid({
    grid_location: {x: GRID_X, y: GRID_Y},
    cell_size: {x_size: CELL_SIZE, y_size: CELL_SIZE},
    grid_dimensions: {x_size: GRID_COLS, y_size: GRID_ROWS}
  })
}

function render_current_board(b, grid) {
  for (let row = 0; row < GRID_ROWS; row++) {
    for (let col = 0; col < GRID_COLS; col++) {
      let light = b.position[row][col];
      let onState = light.on[b];
      let fillColor = getFillColor(onState);

      grid.add({x: col, y: row}, new Rectangle({
        height: CELL_SIZE,
        width: CELL_SIZE,
        color: fillColor}))
    }
  }

}


// --------------- BUTTON CREATION FUNCTIONS ----------------

/**
 * Create the buttons for the visualization
 * @param {Number} N Number of buttons
 * @param {Array<Function>} callbacks Functions to be called when the button is clicked
 * @returns {Array<Rectangle | TextBox>} Array of Rectangle and TextBox objects
 */
// function setup_buttons() {
//   for (let i = 0; i < N; i++) {
//     const text_box = new TextBox({
//         text: BUTTONS[i],
//         coords: { x: BUTTON_TEXT_XS[i], y: BUTTON_TEXT_Y},
//         fontSize: BUTTON_WIDTH / 5.5,
//         color: 'black',
//         events: [ { event: 'click', callback: () => { 
//                     callbacks[i]();
//                     stage.render(svg, document);
//                 } } ]
//     });
//     const box = new Rectangle({
//         coords: { x: BUTTON_XS[i], y: BUTTON_Y},
//         width: BUTTON_WIDTH,
//         height: BUTTON_HEIGHT,
//         color: 'grey',
//     });
//     buttons.push(box);
//     buttons.push(text_box);
// }
// return buttons;
// }



// ------------------- VISUALIZATION -----------------------
const stage = new Stage();


let grid = create_grid()
let board = getStartingBoard()
render_current_board(board, grid)



stage.add(new TextBox({
text: 'Lights Out!', 
coords: {x:250, y:50},
color: 'black',
fontSize: 20
}))
stage.add(grid)


stage.render(svg, document)



