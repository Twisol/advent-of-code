const File = require("fs");

function memory_length(str) {
  str = str.substr(1, str.length-2);

  let count = 0;
  for (let i = 0; i < str.length; ++i) {
    if (str[i] === "\\") {
      i += 1;
      if (str[i] === "x") {
        i += 2;
      }
    }

    count += 1;
  }

  return count;
}

function encoded_length(str) {
  let count = 2;
  for (let i = 0; i < str.length; ++i) {
    if (["\\", "\""].includes(str[i])) {
      count += 1;
    }
    count += 1;
  }
  return count;
}


const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");

const sum_part_1 = lines
  .map(line => line.length - memory_length(line))
  .reduce((acc, n) => acc + n);

const sum_part_2 = lines
  .map(line => encoded_length(line) - line.length)
  .reduce((acc, n) => acc + n);

console.log("Part One: " + sum_part_1);
console.log("Part Two: " + sum_part_2);
