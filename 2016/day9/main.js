const File = require("fs");

function to_length(data, recurse) {
  let decompressed_length = 0;

  while (data.length > 0) {
    if (data[0] === "(") {
      const match = /^\((\d+)x(\d+)\)(.*)$/.exec(data);

      const sublength = recurse(match[3].substr(0, +match[1]), recurse);
      decompressed_length += sublength*(+match[2]);

      data = match[3].substr(+match[1]);
    } else {
      decompressed_length += 1;
      data = data.substr(1);
    }
  }

  return decompressed_length;
}


const data = File.readFileSync("input.txt", "utf-8").trim();

console.log("Part One: " + to_length(data, x => x.length));
console.log("Part Two: " + to_length(data, to_length));
