const File = require("fs");

function look_and_say(str) {
  let result = [];
  let count = 0;
  let current = str[0];
  for (let ch of str) {
    if (current === ch) {
      count += 1;
    } else {
      result.push(""+count, current);
      count = 1;
      current = ch;
    }
  }
  result.push(""+count, current);
  return result;
}


const start = File.readFileSync("input.txt", "utf-8").trim().split("");

let result = start;

for (let i = 0; i < 40; ++i) {
  result = look_and_say(result);
}
const result_part_one = result;

for (let i = 40; i < 50; ++i) {
  result = look_and_say(result);
}
const result_part_two = result;

console.log("Part One: " + result_part_one.length);
console.log("Part Two: " + result_part_two.length);
