const File = require("fs");

class Grid {
  constructor(width, height) {
    this.width = width;
    this.height = height;
    this.grid = [];

    for (let x = 0; x < this.width; x += 1) {
      this.grid.push([]);
      for (let y = 0; y < this.height; y += 1) {
        this.grid[x][y] = ".";
      }
    }
  }

  rect(width, height) {
    width = Math.min(width, this.width);
    height = Math.min(height, this.height);

    for (let y = 0; y < height; y += 1) {
      for (let x = 0; x < width; x += 1) {
        this.grid[x][y] = "#";
      }
    }
  }

  rotate_column(x, amount) {
    const column = [];
    for (let y = 0; y < this.height; y += 1) {
      column.push(this.grid[x][y]);
    }

    for (let y = 0; y < this.height; y += 1) {
      this.grid[x][(y+amount) % this.height] = column[y];
    }
  }

  rotate_row(y, amount) {
    const row = [];
    for (let x = 0; x < this.width; x += 1) {
      row.push(this.grid[x][y]);
    }

    for (let x = 0; x < this.width; x += 1) {
      this.grid[(x+amount) % this.width][y] = row[x];
    }
  }

  count_lit() {
    let total = 0;
    for (let y = 0; y < this.height; y += 1) {
      for (let x = 0; x < this.width; x += 1) {
        total += (this.grid[x][y] === "#") ? 1 : 0;
      }
    }
    return total;
  }

  toString() {
    let output = "";
    for (let y = 0; y < this.height; y += 1) {
      for (let x = 0; x < this.width; x += 1) {
        output += this.grid[x][y];
      }
      output += "\n";
    }
    return output;
  }
}

function parse_command(line) {
  let match;

  if ((match = /^rect (\d+)x(\d+)$/.exec(line))) {
    return (grid) => grid.rect(+match[1], +match[2]);
  } else if ((match = /^rotate row y=(\d+) by (\d+)$/.exec(line))) {
    return (grid) => grid.rotate_row(+match[1], +match[2]);
  } else if ((match = /^rotate column x=(\d+) by (\d+)$/.exec(line))) {
    return (grid) => grid.rotate_column(+match[1], +match[2]);
  }
}


const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const commands = lines.map(parse_command);

const grid = new Grid(50, 6);
for (let command of commands) {
  command(grid);
}

console.log("Part One: " + grid.count_lit());
console.log("Part Two: \n" + grid.toString());
