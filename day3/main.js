const File = require("fs");

const input = File.readFileSync("input.txt", "utf-8").trim().split("");

const lefts  = input.reduce((acc, x) => acc + ((x === "<") ? 1 : 0), 0);
const rights = input.reduce((acc, x) => acc + ((x === ">") ? 1 : 0), 0);
const ups    = input.reduce((acc, x) => acc + ((x === "^") ? 1 : 0), 0);
const downs  = input.reduce((acc, x) => acc + ((x === "v") ? 1 : 0), 0);

const width = lefts + rights + 1;
const height = ups + downs + 1;


function deliver_gifts(input, santas) {
  let newly_gifted = 0;

  const grid = new Uint16Array(width*height);
  for (let i = 0; i < grid.length; ++i) {
    grid[i] = 0;
  }

  // Place our santas at their initial positions
  for (let santa of santas) {
    if (grid[santa.y*width + santa.x] === 0) {
      newly_gifted += 1;
    }
    grid[santa.y*width + santa.x] += 1;
  }

  // Move each santa
  for (let ch of input) {
    const santa = santas.splice(0, 1)[0];

    switch (ch) {
      case "<": santa.x -= 1; break;
      case ">": santa.x += 1; break;
      case "^": santa.y -= 1; break;
      case "v": santa.y += 1; break;
      default: throw new Error("wat");
    }

    if (grid[santa.y*width + santa.x] === 0) {
      newly_gifted += 1;
    }
    grid[santa.y*width + santa.x] += 1;

    santas.push(santa);
  }

  return newly_gifted;
}


console.log("Part One: " + deliver_gifts(input, [
  {x: lefts+1, y: ups+1}, // santa
]));

console.log("Part Two: " + deliver_gifts(input, [
  {x: lefts+1, y: ups+1}, // santa
  {x: lefts+1, y: ups+1}, // robo-santa
]));
