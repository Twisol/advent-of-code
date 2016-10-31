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
  return [...permutations(Object.keys(edges))];

  function* permutations(arr) {
    if (arr.length === 0) {
      yield {path: [], length: 0};
    } else if (arr.length === 1) {
      yield {path: [arr[0]], length: 0};
    } else {
      for (let partial of permutations(arr.slice(1))) {
        yield {
          path: [arr[0], ...partial.path],
          length: partial.length + edges[arr[0]][partial.path[0]],
        };

        for (let i = 1; i < partial.path.length-1; ++i) {
          yield {
            path: [...partial.path.slice(0, i), arr[0], ...partial.path.slice(i)],
            length:
              ( partial.length
              - edges[partial.path[i-1]][partial.path[i]]
              + edges[partial.path[i-1]][arr[0]]
              + edges[arr[0]][partial.path[i]]
              ),
          };
        }

        yield {
          path: [...partial.path, arr[0]],
          length: partial.length + edges[arr[0]][partial.path[partial.path.length-1]],
        };
      }
    }
  }
}

const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n")
const edges = parse_edges(lines);
const routes = all_routes(edges);

const shortest = routes.reduce((best, x) => (best.length <= x.length) ? best : x);
const longest  = routes.reduce((best, x) => (best.length >= x.length) ? best : x);

console.log("Part One: " + shortest.length);
console.log("Part Two: " + longest.length);
