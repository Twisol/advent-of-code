const File = require("fs");

// Left-handed coordinate system for convenience
function move({x, y}, dir) {
  switch (dir) {
    case "L": return {x: x - 1, y: y};
    case "R": return {x: x + 1, y: y};
    case "U": return {x: x, y: y - 1};
    case "D": return {x: x, y: y + 1};
  }
}

// Execute a series of movements on a bounded disc of radius 1.
// (Note that the actual shape of the "disc" depends on the
// metric provided.)
function execute(position, moves, metric) {
  const positions = [];

  for (let dirs of moves) {
    for (let dir of dirs) {
      const next = move(position, dir);
      if (metric(next) <= 1) position = next;
    }
    positions.push(position);
  }

  return positions;
}

const square = {
  metric({x, y}) {  // Chebyshev norm
    return Math.max(Math.abs(x), Math.abs(y));
  },
  display({x, y}) {
    return "123456789"[3*(y + 1) + (x + 1)];
  },
};

const diamond = {
  metric({x, y}) {  // Manhattan norm
    return (Math.abs(x) + Math.abs(y)) / 2;
  },
  display({x, y}) {
    return "  1   234 56789 ABC   D  "[5*(y + 2) + (x + 2)];
  },
};


const moves = File.readFileSync("input.txt", "utf-8").trim()
    .split("\n")
    .map(line => line.split(""));

const square_code =
  execute({x: 0, y: 0}, moves, square.metric)
    .map(square.display)
    .join("");
console.log("Part One: " + square_code);

const diamond_code =
  execute({x: -2, y: 0}, moves, diamond.metric)
    .map(diamond.display)
    .join("");
console.log("Part Two: " + diamond_code);
