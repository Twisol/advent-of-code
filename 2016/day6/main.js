const File = require("fs");

function transpose(rows) {
  const cols = [];
  for (let row of rows) {
    let i = 0;
    for (let x of row) {
      cols[i] = (cols[i] || []);
      cols[i].push(x);
      i += 1;
    }
  }

  return cols;
}

function to_frequencies(list) {
  const freqs = {};
  for (let x of list) {
    freqs[x] = (freqs[x] || 0);
    freqs[x] += 1;
  }

  return freqs;
}

function best_key(obj, metric) {
  const comparator = (x, y) => {
    const score_x = metric(obj[x]);
    const score_y = metric(obj[y]);

    if (score_x < score_y) return 1;
    else if (score_y < score_x) return -1;
    else return 0;
  }

  return Object.keys(obj).sort(comparator)[0];
}

const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const columns = transpose(lines);
const frequencies = columns.map(to_frequencies);

const message1 = frequencies.map(ch => best_key(ch, x =>  x)).join("");
const message2 = frequencies.map(ch => best_key(ch, x => -x)).join("");

console.log("Part One: " + message1);
console.log("Part Two: " + message2);
