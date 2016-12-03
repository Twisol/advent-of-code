const File = require("fs");


function parse_edges(lines) {
  const rex = /(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\./;

  const prefs = {};
  for (let line of lines) {
    const match = rex.exec(line);

    if (!(match[1] in prefs)) prefs[match[1]] = {};
    prefs[match[1]][match[4]] = match[3] * ((match[2] === "gain") ? +1 : -1);
  }

  const edges = {};
  for (let person of Object.keys(prefs)) {
    for (let other of Object.keys(prefs[person])) {
      if (!(person in edges)) edges[person] = {};
      edges[person][other] = prefs[person][other] + prefs[other][person];
    }
    edges[person][person] = 0;
  }

  // Add ourselves to the list
  for (let other of Object.keys(prefs)) {
    if (!("Me" in edges)) edges["Me"] = {};
    edges["Me"][other] = 0;
    edges[other]["Me"] = 0;
  }
  edges["Me"]["Me"] = 0;

  return edges;
}

// Now we can apply our day9 solution! Since there are no left/right edges
// on a round table, we can even simplify some of our code.
function all_arrangements(edges, containing) {
  function* permutations(arr) {
    if (arr.length === 0) {
      yield {path: [], metric: 0};
    } else if (arr.length === 1) {
      yield {path: arr, metric: 0};
    } else {
      for (let {path, metric} of permutations(arr.slice(1))) {
        let old_inner = (i) => edges[path[(i+path.length-1)%path.length]][path[i]];
        let new_left  = (i) => edges[path[(i+path.length-1)%path.length]][arr[0]];
        let new_right = (i) => edges[arr[0]][path[i]];

        for (let i = 0; i < path.length; ++i) {
          yield {
            path: [...path.slice(0, i), arr[0], ...path.slice(i)],
            metric: (metric - old_inner(i) + new_left(i) + new_right(i)),
          };
        }
      }
    }
  }

  return [...permutations(containing)];
}


const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const edges = parse_edges(lines);

const arrangements = all_arrangements(edges, Object.keys(edges).filter(x => x !== "Me"));
const happiest = arrangements.reduce((best, x) => (best.metric >= x.metric) ? best : x);

const arrangements_with_me = all_arrangements(edges, Object.keys(edges));
const happiest_with_me = arrangements_with_me.reduce((best, x) => (best.metric >= x.metric) ? best : x);

console.log("Part One: " + happiest.metric);
console.log("Part Two: " + happiest_with_me.metric);
