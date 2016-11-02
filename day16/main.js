const File = require("fs");


function parse_sues(lines) {
  const rex = /Sue (\d+): ([^:]+): (\d+), ([^:]+): (\d+), ([^:]+): (\d+)/;

  const sues = [];
  for (let line of lines) {
    const match = rex.exec(line);
    sues.push({
      index: +match[1],
      [match[2]]: +match[3],
      [match[4]]: +match[5],
      [match[6]]: +match[7],
    });
  }

  return sues;
}

function parse_clue(lines) {
  const rex = /([^:]+): (\d+)/;

  const clue = {};
  for (let line of lines) {
    const match = rex.exec(line);
    clue[match[1]] = +match[2];
  }

  return clue;
}

function find_sue(sues, clue, predicate) {
  let possibilities = sues;
  for (let clue_name of Object.keys(clue)) {
    possibilities = possibilities.filter(sue => predicate(sue, clue_name));
  }

  return possibilities[0];
}


const sue_lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const sues = parse_sues(sue_lines);

const clue_lines = File.readFileSync("clue.txt", "utf-8").trim().split("\n");
const clue = parse_clue(clue_lines);

const sue_1 = find_sue(sues, clue, (sue, clue_name) => {
  return !(clue_name in sue) || sue[clue_name] == clue[clue_name];
});

const sue_2 = find_sue(sues, clue, (sue, clue_name) => {
  if (!(clue_name in sue)) {
    return true;
  } else if (["cats", "trees"].includes(clue_name)) {
    return sue[clue_name] > clue[clue_name];
  } else if (["pomeranians", "goldfish"].includes(clue_name)) {
    return sue[clue_name] < clue[clue_name];
  } else {
    return sue[clue_name] === clue[clue_name]
  }
});

console.log("Part One: " + sue_1.index);
console.log("Part Two: " + sue_2.index);
