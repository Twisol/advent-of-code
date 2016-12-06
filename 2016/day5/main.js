const File = require("fs");
const Crypto = require("crypto");

function* naturals() {
  let i = 0;
  while (true) {
    yield i;
    i += 1;
  }
}

function* filter(gen, predicate) {
  for (let x of gen) {
    if (predicate(x)) yield x;
  }
}

function* map(gen, f) {
  for (let x of gen) {
    yield f(x);
  }
}

function* take(gen, n) {
  let i = 0;
  for (let x of gen) {
    if (i >= n) break;
    yield x;
    i += 1;
  }
}

function md5(str) {
  return Crypto.createHash('md5').update(str).digest("hex");
}

function is_interesting(str) {
  return !!str.match(/^0{5}/);
}

const room_id = File.readFileSync("input.txt", "utf-8").trim();
const interesting = [...take(filter(map(naturals(), n => md5(room_id+n)), is_interesting), 8)];

let password1 = "--------".split("");
let password2 = "--------".split("");
let marked = "nnnnnnnn".split("");
let i1 = 0;
let i2 = 0;
for (let hash of map(naturals(), n => md5(room_id+n))) {
  if (i2 >= 8) {
    break;
  }

  if (!is_interesting(hash)) {
    continue;
  }

  if (i1 < 8) {
    password1[i1] = hash[5];
    i1 += 1;
  }

  if (i2 < 8 && parseInt(hash[5], 16) < 8 && marked[parseInt(hash[5], 16)] === "n") {
    password2[parseInt(hash[5], 16)] = hash[6];
    marked[parseInt(hash[5], 16)] = "y";
    i2 += 1;
  }
}

console.log("Part One: " + password1.join(""));
console.log("Part Two: " + password2.join(""));
