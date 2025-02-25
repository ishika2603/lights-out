const SCREEN_WIDTH = 500;
const SCREEN_HEIGHT = 500;
const GRID_SIZE = 5; // Adjust based on instance
const CELL_SIZE = SCREEN_WIDTH / GRID_SIZE;

// Main function to draw grid based on the model state
function updateGrid(instance) {
    d3.select("#viz").selectAll("*").remove(); // Clear previous visualization

    const svg = d3.select("#viz")
        .append("svg")
        .attr("width", SCREEN_WIDTH)
        .attr("height", SCREEN_HEIGHT);

    // Get active lights from the Forge model
    let lightsOn = instance.signature("Light").atoms().map(light => get_index(light.id()));

    for (let row = 0; row < GRID_SIZE; row++) {
        for (let col = 0; col < GRID_SIZE; col++) {
            const id = row * GRID_SIZE + col;
            const isOn = lightsOn.includes(id);

            svg.append("rect")
                .attr("x", col * CELL_SIZE)
                .attr("y", row * CELL_SIZE)
                .attr("width", CELL_SIZE)
                .attr("height", CELL_SIZE)
                .attr("fill", isOn ? "yellow" : "black")
                .attr("stroke", "white");
        }
    }
}

// Register update function when the model changes
viz.onModelChange(updateGrid);
