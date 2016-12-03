const File = require("fs");


function execute(actions) {
  const rex = /(turn on|toggle|turn off) (\d+),(\d+) through (\d+),(\d+)/;

  const grid = new Uint8Array(1000*1000);
  for (let i = 0; i < grid.length; ++i) {
    grid[i] = 0;
  }

  for (let command of commands) {
    const match = rex.exec(command);

    const action = actions[match[1]];
    const topleft = {x: +match[2], y: +match[3]};
    const bottomright = {x: +match[4], y: +match[5]};

    for (let y = topleft.y; y <= bottomright.y; ++y) {
      for (let x = topleft.x; x <= bottomright.x; ++x) {
        grid[y*1000+x] = action(grid[y*1000+x]);
      }
    }
  }

  let on_count = 0;
  for (let i = 0; i < grid.length; ++i) {
    on_count += grid[i];
  }

  return on_count;
}


const actions_1 = {
  "turn on":  ((cell) => 1),
  "turn off": ((cell) => 0),
  "toggle":   ((cell) => 1 - cell),
};

const actions_2 = {
  "turn on":  ((cell) => cell + 1),
  "turn off": ((cell) => Math.max(0, cell -1)),
  "toggle":   ((cell) => cell + 2),
};

const commands = File.readFileSync("input.txt", "utf-8").trim().split("\n");
console.log("Part One: " + execute(actions_1));
console.log("Part Two: " + execute(actions_2));
