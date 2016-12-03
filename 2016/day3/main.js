const File = require("fs");

function is_possible([a, b, c]) {
  return (a + b > c && b + c > a && c + a > b);
}

function transpose(tris) {
  const transposed = [];
  for (let i = 0; i < tris.length; i += 3) {
    for (let j = 0; j < 3; j += 1) {
      transposed.push([tris[i+0][j], tris[i+1][j], tris[i+2][j]])
    }
  }

  return transposed;
}


const triangles =
  File.readFileSync("input.txt", "utf-8").trim()
    .split("\n")
    .map(line => {
      return line.trim().split(/\s+/).map(side => +side)
    });

console.log("Part One: " + triangles.filter(is_possible).length);
console.log("Part Two: " + transpose(triangles).filter(is_possible).length);
