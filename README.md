# Lights Out Puzzle

## Project Objective
The goal is to model the Lights Out puzzle, a grid-based game where pressing a cell toggles its state and adjacent cells. The challenge is to find a sequence of presses that turns all lights off starting from an initial configuration (all lights on).

## Model Design and Visualization
- **Grid Structure**: A 3x3 grid modeled using ordered rows and columns.
- **Adjacency**: Cells are adjacent if they share a row or column and are next to each other.
- **State Transitions**: Pressing a cell toggles its state and its neighbors'.
- **Visualization**: Uses default Forge visualization showing cell states and adjacency relations.

## Signatures and Predicates
- **Row, Col**: Ordered sigs for grid positions.
- **Cell**: Represents a cell with `row`, `col`, `adj` (adjacent cells), and `state`.
- **init**: Initializes all cells to on.
- **press**: Defines the state transition when a cell is pressed.
- **solve**: Finds a sequence leading to all cells off.

## Testing
- **pressingCellTogglesCorrectly**: Ensures pressing a cell toggles the correct cells.
- **solutionExists**: Verifies a solution exists for the all-on configuration.

## Documentation
Code is commented to explain sigs and predicates. Tests validate model behavior and solution existence.