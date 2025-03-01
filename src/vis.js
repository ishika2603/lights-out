// -------------------- CONSTANTS --------------------------

const GRID_ROWS = 3;  
const GRID_COLS = 3;        
const CELL_SIZE = 100;       
const GRID_MARGIN = 20;   
const GRID_Y = 100;
const GRID_X = 100;

const LIGHT_ON_COLOR = "#FFD700";
const LIGHT_OFF_COLOR = "#333333";
const CELL_BORDER_COLOR = "black";
const CELL_BORDER_WIDTH = 3;

const EXTRA_HEIGHT = 100;
const SVG_WIDTH = GRID_COLS * CELL_SIZE + 2 * GRID_MARGIN;
const SVG_HEIGHT = GRID_ROWS * CELL_SIZE + 2 * GRID_MARGIN + EXTRA_HEIGHT;

const BUTTONS = ['NEXT'];
const BUTTON_WIDTH = SVG_WIDTH / BUTTONS.length * 0.2;
const BUTTON_HEIGHT = (SVG_HEIGHT) * 0.1;
const BUTTON_Y = GRID_Y * 4.25;
const BUTTON_XS = GRID_X * 2.15;

const BUTTON_TEXT_Y = BUTTON_Y + BUTTON_HEIGHT / 2;
const BUTTON_TEXT_XS = BUTTON_XS + BUTTON_WIDTH / 2;

const svgContainer = document.getElementById('svg-container');
svgContainer.getElementsByTagName('svg')[0].style.height = `${SVG_HEIGHT}px`;
svgContainer.getElementsByTagName('svg')[0].style.width = `${SVG_WIDTH}px`;

// -------------------- HELPER/FORGE FUNCTIONS --------------

/**
 * returns corresponding color based on light state
 */
function getFillColor(bo) {
  return bo.id() === "True0" ? LIGHT_ON_COLOR : LIGHT_OFF_COLOR;
}

/**
 * Returns an array of all Board atoms in instance.
 * (assumes next is linear is being called)
 */
function getAllBoards() {
  return instance.signature('Board').atoms();
}


// --------------- BOARD CREATION FUNCTIONS ----------------

/**
 * creates grid for board
 * @returns Grid object
 */
function create_grid() {
  return new Grid({
    grid_location: {x: GRID_X, y: GRID_Y},
    cell_size: {x_size: CELL_SIZE, y_size: CELL_SIZE},
    grid_dimensions: {x_size: GRID_COLS, y_size: GRID_ROWS}
  })
}

/**
 * renders current board b onto the existing grid
 */
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

/**
 * Checks whether board b is solved.
 * Returns true if every cell's light is off, false otherwise.
 */
function isSolved(b) {
  for (let row = 0; row < GRID_ROWS; row++) {
    for (let col = 0; col < GRID_COLS; col++) {
      let light = b.position[row][col];
      let onState = light.on[b];
      if (onState.id() === "True0") {
        return false;
      }
    }
  }
  return true;
}

// --------------- BUTTON CREATION FUNCTIONS ----------------

/**
 * creates button
 * @returns list of buttons (one in this case)
 */
function setup_buttons(N, callbacks) {
  let buttons = [];
  for (let i = 0; i < N; i++) {
    const text_box = new TextBox({
        text: BUTTONS[i],
        coords: { x: BUTTON_TEXT_XS, y: BUTTON_TEXT_Y},
        fontSize: BUTTON_WIDTH / 4,
        color: 'black',
        events: [ { event: 'click', callback: () => { 
                    callbacks[i]();
                    stage.render(svg, document);
                } } ]
    });
    const box = new Rectangle({
        coords: { x: BUTTON_XS, y: BUTTON_Y},
        width: BUTTON_WIDTH,
        height: BUTTON_HEIGHT,
        color: 'grey',
    });

    buttons.push(box);
    buttons.push(text_box);
}
return buttons;
}

/**
 * updates grid board when next button is clicked
 */
function next_button(boards, grid, statusTextBox) {

  if (currentIndex < boards.length - 1) {
    currentIndex++;
    stage.remove(grid);
    grid = create_grid();
    render_current_board(boards[currentIndex], grid);
    stage.add(grid);
    
    if (currentIndex === boards.length - 1) {
      if (isSolved(boards[currentIndex])) {
        statusTextBox.setText("SOLVED");
      } else {
        statusTextBox.setText("uh oh - something went wrong");
      }
    } else {
      statusTextBox.setText("Step: " + currentIndex);
    }
  }
}

// ------------------- VISUALIZATION -----------------------

const stage = new Stage();
let boards = getAllBoards();
let currentIndex = 0;

let statusTextBox = new TextBox({
  text: 'Step: 0', 
  coords: { x: 250, y: 30 },
  color: 'black',
  fontSize: 20
});

let grid = create_grid()
render_current_board(boards[currentIndex], grid);

stage.add(statusTextBox);

let buttons = setup_buttons(BUTTONS.length, 
  [() => next_button(boards, grid, statusTextBox)])

buttons.forEach(button => stage.add(button));

stage.add(new TextBox({
text: 'Lights Out!', 
coords: {x:250, y:50},
color: 'black',
fontSize: 20
}))
stage.add(grid)

stage.render(svg, document)



