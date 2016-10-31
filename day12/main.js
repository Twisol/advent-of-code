const File = require("fs");

// A `reduce` function over JSON documents
function walk(doc, f) {
  switch (doc.constructor) {
    case Array:   return f.Array(doc, () => doc.map(x => walk(x, f)));
    case Object:  return f.Object(doc, () => {
      return Object.keys(doc).reduce((acc, k) => {
        acc[k] = walk(doc[k], f);
        return acc;
      }, {});
    });
    case Number:  return f.Number(doc);
    case String:  return f.String(doc);
    case Boolean: return f.Boolean(doc);
    default: throw new Error("wat");
  }
}


const doc = JSON.parse(File.readFileSync("input.txt", "utf-8"));

const all_sum = walk(doc, {
  Array: (doc, recurse) => recurse().reduce((acc, x) => acc + x, 0),
  Object: (doc, recurse) => {
    return Object.values(recurse()).reduce((acc, x) => acc + x, 0);
  },
  Number: (doc) => doc,
  String: (doc) => 0,
  Boolean: (doc) => 0,
});

const nonred_sum = walk(doc, {
  Array: (doc, recurse) => recurse().reduce((acc, x) => acc + x, 0),
  Object: (doc, recurse) => {
    if (Object.values(doc).includes("red")) {
      return 0;
    } else {
      return Object.values(recurse()).reduce((acc, x) => acc + x, 0);
    }
  },
  Number: (doc) => doc,
  String: (doc) => 0,
  Boolean: (doc) => 0,
})

console.log("Part One: " + all_sum);
console.log("Part Two: " + nonred_sum);


// const rex = /(-?\d+)/g;

// let sum = 0;
// while ((match = rex.exec(doc))) {
//   sum += +match[1];
// }

// console.log(sum);
