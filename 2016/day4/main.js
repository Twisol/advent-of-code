const File = require("fs");


function is_valid({name, checksum}) {
  const freq = {};
  for (let ch of name) {
    if (ch < 'a' || 'z' < ch) continue;
    freq[ch] = (freq[ch] || 0) + 1;
  }

  const common =
    Object.keys(freq).sort(function(x, y) {
      if      (freq[x] > freq[y]) return -1;
      else if (freq[x] < freq[y]) return  1;
      else if (x < y)             return -1;
      else if (x > y)             return  1;
      else                        return  0;
    });

  return (common.slice(0, 5).join("") === checksum);
}

function decrypt({name, sector}) {
  const alphabet = "abcdefghijklmnopqrstuvwxyz";
  return (
    name
      .split("")
      .map(ch => {
        let v = alphabet.indexOf(ch);
        if (v === -1) {
          return " ";
        } else {
          return alphabet[(v+sector) % alphabet.length];
        }
      })
      .join("")
  );
}

const encrypted_rooms =
  File.readFileSync("input.txt", "utf-8").trim()
    .split("\n")
    .map(line => {
      const rex = /([a-z-]+)-(\d+)\[([a-z]+)\]/;
      const match = rex.exec(line);
      return {
        name: match[1],
        sector: +match[2],
        checksum: match[3],
      };
    });

const rooms =
  encrypted_rooms
    .filter(is_valid)
    .reduce((d, r) => Object.assign(d, {[decrypt(r)]: r}), {})

const sum =
  Object.values(rooms)
    .map(room => room.sector)
    .reduce((x, y) => x + y, 0);

console.log("Part One: " + sum);
console.log("Part Two: " + rooms["northpole object storage"].sector);
