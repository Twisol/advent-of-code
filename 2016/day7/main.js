const File = require("fs");

function any(list, predicate) {
  for (let x of list) {
    if (predicate(x)) return true;
  }
  return false;
}


function parts_of(line) {
  const parts = {good: [], bad: []};

  let last_bracket = -1;
  while (true) {
    const start_bracket = line.indexOf("[", last_bracket);
    const end_bracket = line.indexOf("]", start_bracket);
    if (start_bracket === -1) break;

    if (last_bracket+1 < start_bracket) {
      parts.good.push(line.substring(last_bracket+1, start_bracket));
    }

    if (start_bracket+1 < end_bracket) {
      parts.bad.push(line.substring(start_bracket+1, end_bracket));
    }

    last_bracket = end_bracket;
  }

  if (last_bracket+1 < line.length) {
    parts.good.push(line.substring(last_bracket+1));
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
