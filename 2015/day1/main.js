const File = require("fs");


function final_floor(parens) {
  let floor = 0;
  for (let ch of parens) {
    if (ch === "(") {
      floor += 1;
    } else if (ch === ")") {
      floor -= 1;
    }
  }

  return floor;
}

function when_basement(parens) {
  let floor = 0;
  for (let i = 0; i < parens.length; ++i) {
    if (parens[i] === "(") {
      floor += 1;
    } else if (parens[i] === ")") {
      floor -= 1;
      if (floor < 0) {
        return i+1;
      }
    }
  }

  return null;
}

const input = File.readFileSync("input.txt", "utf-8");

console.log("Part One: " + final_floor(input));
console.log("Part Two: " + when_basement(input));
