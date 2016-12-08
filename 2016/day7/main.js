const File = require("fs");

function any(list, predicate) {
  for (let x of list) {
    if (predicate(x)) return true;
  }
  return false;
}


function parts_of(line) {
  const splits = line.split(/\[|\]/)

  const parts = {good: [], bad: []};
  for (let i = 0; i < splits.length; i += 1) {
    if (i % 2 == 0) parts.good.push(splits[i]);
    else            parts.bad.push(splits[i]);
  }

  return parts;
}


function has_abba(str) {
  return !!(/([a-z])(?!\1)([a-z])\2\1/.exec(str));
}

function find_aba(str) {
  const rex = /([a-z])(?!\1)([a-z])\1/g;

  const accessors = [];
  let match;
  while ((match = rex.exec(str))) {
    accessors.push(match[0]);
    rex.lastIndex -= match[0].length - 1;
  }

  return accessors;
}


function supports_tls(line) {
  const parts = parts_of(line);

  return !any(parts.bad, has_abba) && any(parts.good, has_abba);
}

function supports_ssl(line) {
  const concat = (a, b) => a.concat(b);
  const invert_aba = (aba) => aba[1] + aba[0] + aba[1];

  const parts = parts_of(line);
  const accessors = parts.good.map(find_aba).reduce(concat, []);
  const blocks = parts.bad.map(find_aba).reduce(concat, []);

  return any(accessors, aba => blocks.includes(invert_aba(aba)));
}


const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");

console.log("Part One: " + lines.filter(supports_tls).length);
console.log("Part Two: " + lines.filter(supports_ssl).length);
