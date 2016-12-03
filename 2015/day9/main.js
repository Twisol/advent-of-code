const File = require("fs");

function parse_edges(lines) {
  const edges = {};
  for (let line of lines) {
    const match = /(\w+) to (\w+) = (\d+)/.exec(line);

    if (!(match[1] in edges)) edges[match[1]] = {};
    if (!(match[2] in edges)) edges[match[2]] = {};

    edges[match[1]][match[2]] = +match[3];
    edges[match[2]][match[1]] = +match[3];
  }

  return edges;
}

function all_routes(edges) {
  function* permutations(arr) {
    if (arr.length === 0) {
      yield {path: [], length: 0};
    } else {
      for (let {path, length} of permutations(arr.slice(1))) {
        let old_inner = (i) => (0 < i && i < path.length) ? edges[path[i-1]][path[i]] : 0;
        let new_left  = (i) => (0 < i                   ) ? edges[path[i-1]][arr[0]]  : 0;
        let new_right = (i) => (         i < path.length) ? edges[arr[0]][path[i]]    : 0;

        for (let i = 0; i <= path.length; ++i) {
          yield {
            path: [...path.slice(0, i), arr[0], ...path.slice(i)],
            length: (length - old_inner(i) + new_left(i) + new_right(i)),
          };
        }
      }
    }
  }

  return [...permutations(Object.keys(edges))];
}


const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n")
const edges = parse_edges(lines);
const routes = all_routes(edges);

const shortest = routes.reduce((best, x) => (best.length <= x.length) ? best : x);
const longest  = routes.reduce((best, x) => (best.length >= x.length) ? best : x);

console.log("Part One: " + shortest.length);
console.log("Part Two: " + longest.length);
