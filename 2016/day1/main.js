const File = require("fs");


// A little linear algebra goes a long way.
function* find_first_place(moves) {
  let position = {x: 0, y: 0};
  let heading = {x: 0, y: 1};

  yield position;

  for ({dir, steps} of moves) {
    if (dir === "L") {
      heading = {x: -heading.y, y:  heading.x};
    } else if (dir === "R") {
      heading = {x:  heading.y, y: -heading.x};
    }

    for (let i = 0; i < steps; i += 1) {
      position.x += heading.x;
      position.y += heading.y;

      yield position;
    }
  }
}


const moves =
  File.readFileSync("input.txt", "utf-8").trim()
    .split(", ")
    .map(s => ({
      dir: s[0],
      steps: +s.substr(1),
    }));

let end_place = null;
for (let place of find_first_place(moves)) {
  end_place = place;
}
console.log("Part One: " + (Math.abs(end_place.x) + Math.abs(end_place.y)));

let doubled_place = null;
const cache = {};
for (let place of find_first_place(moves)) {
  const key = ""+place.x+","+place.y;
  cache[key] = (cache[key] || 0) + 1;

  if (cache[key] > 1) {
    doubled_place = place;
    break;
  }
}
console.log("Part Two: " + (Math.abs(doubled_place.x) + Math.abs(doubled_place.y)));
