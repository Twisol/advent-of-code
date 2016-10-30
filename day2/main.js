const File = require("fs");

const input = File.readFileSync("input.txt", "utf-8").trim();

let dimses = input
  .split("\n")
  .map(spec =>
    spec
      .split("x")
      .map(x => parseInt(x, 10))
      .sort((x, y) => x >= y)
  );

let total_paper = dimses
  .map(([x, y, z]) => 3*x*y + 2*x*z + 2*y*z)
  .reduce((acc, x) => acc + x, 0);

let total_ribbon = dimses
  .map(([x, y, z]) => 2*x + 2*y + x*y*z)
  .reduce((acc, x) => acc + x, 0);

console.log("Part One: " + total_paper);
console.log("Part Two: " + total_ribbon);
