const File = require("fs");

function initialize_grid(input) {
  const grid = new Uint8Array(100*100);
  for (let i = 0; i < input.length; ++i) {
    grid[i] = (input[i] === "#") ? 1 : 0;
  }

  return grid;
}

function set_stuck_lights(grid) {
  const fixed = new Uint8Array(grid);
  fixed[0*100+0]   = 1;
  fixed[99*100+0]  = 1;
  fixed[0*100+99]  = 1;
  fixed[99*100+99] = 1;
  return fixed;
}

function step_grid(prev) {
  const get = (x, y) => {
    if (0 <= x && x < 100  &&  0 <= y && y < 100) {
      return prev[y*100+x];
    } else {
      return 0;
    }
  };

  const grid = new Uint8Array(100*100);
  for (let y = 0; y < 100; ++y) {
    for (let x = 0; x < 100; ++x) {
      const sum =
        ( get(x-1, y-1) + get(x  , y-1) + get(x+1, y-1)
        + get(x-1, y  )                 + get(x+1, y  )
        + get(x-1, y+1) + get(x  , y+1) + get(x+1, y+1)
        );

      if (prev[y*100+x] === 1) {
        grid[y*100+x] = (sum === 2 || sum === 3) ? 1 : 0;
      } else {
        grid[y*100+x] = (sum === 3) ? 1 : 0;
      }
    }
  }

  return grid;
}

function count_lit(grid) {
  let count = 0;
  for (let i = 0; i < 100*100; ++i) {
    count += grid[i];
  }
  return count;
}


const input = File.readFileSync("input.txt", "utf-8").trim().split(/\s*/m);

let grid = initialize_grid(input);
let stuck = set_stuck_lights(grid);
for (let i = 0; i < 100; ++i) {
  grid = step_grid(grid);
  stuck = set_stuck_lights(step_grid(stuck));
}

console.log("Part One: " + count_lit(grid));
console.log("Part Two: " + count_lit(stuck));
