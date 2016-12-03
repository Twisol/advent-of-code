const File = require("fs");


function naughtyOrNice_part1(str) {
  const double_letter = /([a-zA-Z])\1/;
  const forbidden = /ab|cd|pq|xy/;
  const vowels = /[aeiou]/g;

  if (!double_letter.exec(str)) {
    return "naughty";
  } else if (forbidden.exec(str)) {
    return "naughty";
  } else {
    // We want three vowels!
    // Note that since `vowels` has the `g` flag, it's stateful.
    if (!vowels.exec(str)) return "naughty";
    if (!vowels.exec(str)) return "naughty";
    if (!vowels.exec(str)) return "naughty";
  }

  return "nice";
}

function naughtyOrNice_part2(str) {
  const pairs = /([a-zA-Z]{2}).*\1/;
  const singles = /([a-zA-Z]).\1/;

  if (!pairs.exec(str)) {
    return "naughty";
  } else if (!singles.exec(str)) {
    return "naughty";
  }

  return "nice";
}


const strings = File.readFileSync("input.txt", "utf-8").trim().split("\n");

const nice_count_1 = strings
  .map(naughtyOrNice_part1)
  .reduce((acc, x) => acc + ((x === "nice") ? 1 : 0), 0);

const nice_count_2 = strings
  .map(naughtyOrNice_part2)
  .reduce((acc, x) => acc + ((x === "nice") ? 1 : 0), 0);

console.log("Part One: " + nice_count_1);
console.log("Part Two: " + nice_count_2);
