const SCREEN_WIDTH = 500;
const SCREEN_HEIGHT = 500;

const GRID_SIZE = 5; // Adjust based on instance
const CELL_SIZE = SCREEN_WIDTH / GRID_SIZE;



function get_lights_on() {
    return instance.signature('Light').atoms().map(light => {
        return get_index(light.id()); // Extract light index from its name
    });
}

function create_grid(lights_on) {
    const svg = d3.select("#game").append("svg")
        .attr("width", SCREEN_WIDTH)
        .attr("height", SCREEN_HEIGHT);

    for (let row = 0; row < GRID_SIZE; row++) {
        for (let col = 0; col < GRID_SIZE; col++) {
            const id = row * GRID_SIZE + col;
            const isOn = lights_on.includes(id);

            svg.append("rect")
                .attr("x", col * CELL_SIZE)
                .attr("y", row * CELL_SIZE)
                .attr("width", CELL_SIZE)
                .attr("height", CELL_SIZE)
                .attr("fill", isOn ? "yellow" : "black")
                .attr("stroke", "white")
                .on("click", () => toggle_light(id));
        }
    }
}


function toggle_light(id) {
    let row = Math.floor(id / GRID_SIZE);
    let col = id % GRID_SIZE;
    
    let togglePositions = [
        id, // The clicked light
        (row > 0) ? id - GRID_SIZE : null, // Top
        (row < GRID_SIZE - 1) ? id + GRID_SIZE : null, // Bottom
        (col > 0) ? id - 1 : null, // Left
        (col < GRID_SIZE - 1) ? id + 1 : null // Right
    ].filter(x => x !== null);

    togglePositions.forEach(toggleId => {
        let rect = d3.select(`rect:nth-child(${toggleId + 1})`);
        let newColor = rect.attr("fill") === "yellow" ? "black" : "yellow";
        rect.attr("fill", newColor);
    });

    // Update the Forge model if needed
}
const lightsOn = get_lights_on();
create_grid(lightsOn);
