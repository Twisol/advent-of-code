const File = require("fs");

function* solutions(containers, liters) {
  if (containers.length <= 0) {
    if (liters <= 0) {
      yield [];
    }
  } else {
    if (containers[0] <= liters) {
      for (let sequence of solutions(containers.slice(1), liters-containers[0])) {
        yield [containers[0], ...sequence];
      }
    }

    yield* solutions(containers.slice(1), liters);
  }
}

const containers =
  File.readFileSync("input.txt", "utf-8")
    .trim()
    .split("\n")
    .map(x => +x);

containers.sort((x, y) => (x < y) ? 1 : (x > y) ? -1 : 0);

const sequences = [...solutions(containers, 150)];
const lengths =
  sequences
    .map(x => x.length)
    .sort((x, y) => (x < y) ? 1 : (x > y) ? -1 : 0);

const counts = [1];
let last = lengths[0];
for (let el of lengths.slice(1)) {
  if (el !== last) {
    counts.push(1);
    last = el;
  } else {
    counts[counts.length-1] += 1;
  }
}

console.log("Part One: " + sequences.length);
console.log("Part Two: " + counts[counts.length-1]);
