const File = require("fs");

function* repetitions_in(line, include_subreps) {
  const rex = /\((\d+)x(\d+)\)/g;

  let match;
  while ((match = rex.exec(line))) {
    yield {start: match.index, length: match[0].length, strength: 0};
    yield {start: rex.lastIndex, length: +match[1], strength: +match[2]};

    if (!include_subreps) rex.lastIndex += (+match[1]);
  }
}

function decompressed_length(line, is_v2) {
  const weights = (new Uint32Array(data.length)).fill(1);

  for (let rep of repetitions_in(data, is_v2)) {
    for (let i = 0; i < rep.length; i += 1) {
      weights[rep.start+i] *= rep.strength;
    }
  }

  return weights.reduce((x, y) => x + y, 0);
}


const data = File.readFileSync("input.txt", "utf-8").trim();

console.log("Part One: " + decompressed_length(data, false));
console.log("Part Two: " + decompressed_length(data, true));
