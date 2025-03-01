# Lights Out Puzzle

## Project Objective
The goal is to model the Lights Out puzzle, a 3x3 grid-based game where pressing a cell toggles its state and adjacent cells. The challenge is to find a sequence of presses that turns all lights off starting from an initial configuration.

## Model Design and Visualization

### Grid Structure
- The game consists of a 3x3 grid.
- Each cell is represented as a `Light` signature.

### Neighbor Relations
- Each `Light` has pointers (`up`, `down`, `left`, `right`) to adjacent lights.
- Edge cells have some pointers set to null.

### State Transitions
- `Board` signatures track light states through a partial function `on`.
- Pressing a cell toggles its state and adjacent lights.

### Visualization
- Uses Forge’s Sterling visualizer to display board states and transitions.

---

### Initial and Solved Conditions
Below are visual representations of the puzzle's initial state (Some lights on) and the solved state (all lights off).

#### Initial State (Some Lights On)
![Example of Initial State](images/initial_state.png)

#### Solved State (All Lights Off)
![Solved State](images/solved_state.png)
---

## Core Components

### Signatures

- **Boolean**: Abstract type with concrete `True` and `False` atoms.
- **Light**: Represents a cell with:
  - `on`: Partial function mapping `Board` to state (`True` = on).
  - `up`, `down`, `left`, `right`: Neighbor pointers.
- **Board**: Represents a game state with:
  - `position`: Mapping `(row, col) → Light`.
  - `next`: Transition to the next board state.

### Key Predicates

#### `wellformed[b: Board]`
Ensures a valid 3x3 grid structure:
- All positions (0-2, 0-2) are assigned `Lights`.
- No duplicate `Lights`.
- Correct neighbor assignments.

#### `init[b: Board]`
Defines an initial game state:
- All `Lights` are randomly on or off.
- At least one `Light` is on.

#### `toggle[pre, post: Board, row, col: Int]`
Defines a valid move:
- Toggles the `Light` at `(row, col)` and its adjacent neighbors.
- Preserves grid structure.

#### `solved[b: Board]`
Victory condition:
- All `Lights` are off (`on[b] = False`).

#### `gameTrace`
Valid sequence of board states:
- Starts from `init`.
- Ends at `solved`.
- All transitions occur via `toggle`.

---

## Test Suite Documentation

### `validneighbors` Test Suite

| Test Name | Type | Description |
|-----------|------|-------------|
| `goodNeighbors` | ✅ Positive | Validates correct neighbor assignments in a well-formed 3x3 grid. |
| `badNeighbors1` | ❌ Negative | Detects incorrect neighbor assignment (`L00.down` set to `L11` instead of `L10`). |

### `wellformed` Test Suite

| Test Name | Type | Description |
|-----------|------|-------------|
| `validWellformedBoard` | ✅ Positive | Valid 3x3 grid with correct positions and neighbors. |
| `invalidWellformedBoard` | ❌ Negative | Incorrect neighbor assignments (`L00.right` jumps to `L02`). |
| `invalidWellformedBoard2` | ❌ Negative | Missing `Light` position (`L00` not placed). |
| `invalidpositionforwellformed` | ❌ Negative | Duplicate `Light` position (`L01` appears at `(0,1)` and `(0,2)`). |

### `solved` Test Suite

| Test Name | Type | Description |
|-----------|------|-------------|
| `winningboard` | ✅ Positive | All lights are off in a single board. |
| `anotherwinningboard` | ✅ Positive | Multi-board configuration reaching a solved state. |
| `losingboard` | ❌ Negative | At least one light remains on. |

### `init` Test Suite

| Test Name | Type | Description |
|-----------|------|-------------|
| `validInit` | ✅ Positive | Valid initial state with at least one light on. |
| `invalidInit` | ❌ Negative | Invalid initial state with all lights off. |

### `toggle` Test Suite

| Test Name | Type | Description |
|-----------|------|-------------|
| `validToggleCenter` | ✅ Positive | Toggles center cell `(1,1)` correctly. |
| `validToggleSide` | ✅ Positive | Toggles edge cell `(2,1)`, ensuring correct neighbor handling. |

---

## Documentation
- Code is commented to explain each function, transition, and constraint.
- Tests validate model behavior and solution existence.
