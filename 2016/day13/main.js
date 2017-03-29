const File = require("fs");


function popcount(n) {
  const lookup = [0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4];

  let count = 0;
  while (n > 0) {
    count += lookup[n & 0b1111];
    n >>= 4;
  }
  return count;
}

function to_hash({x, y, z}) {
  return x + "," + y + "," + z;
}

function is_wall({x, y, z}) {
  return (popcount(x*x + 3*x + 2*x*y + y + y*y + z) % 2 == 1);
}

function* neighbors_of({x, y, z}) {
  const adjacent = [
    {x: x-1, y     , z},
    {x: x+1, y     , z},
    {x     , y: y-1, z},
    {x     , y: y+1, z},
  ];

  for (let neighbor of adjacent) {
    if (neighbor.x < 0 || neighbor.y < 0) continue;
    if (is_wall(neighbor)) continue;
    yield neighbor;
  }
}

function* heuristic({x1, y1, z1}, {x2, y2, z2}) {
  return Math.abs(x2 - x1) + Math.abs(y2 - y1) + Math.abs(z2 - z1);
}

function* a_star(start, neighbors_of, to_hash, heuristic_for) {
  const queue = [];
  const visited = {};

  {
    const new_record = {
      steps: 0,
      remaining: heuristic_for(start),
      state: start,
      hash: to_hash(start),
    };
    queue.push(new_record);
    visited[to_hash(new_record.state)] = new_record;
  }

  while (queue.length > 0) {
    const record = queue.shift();

    yield record;

    for (let neighbor of neighbors_of(record.state)) {
      const hash = to_hash(neighbor);
      if (visited[hash]) continue;

      const new_record = {
        steps: record.steps + 1,
        remaining: heuristic_for(neighbor),
        state: neighbor,
        hash: hash,
      };
      visited[hash] = new_record;

      let i;
      for (i = 0; i < queue.length; i += 1) {
        if (new_record.steps + new_record.remaining <= queue[i].steps + queue[i].remaining) {
          queue.splice(i, 0, new_record);
          break;
        }
      }
      if (i === queue.length) {
        queue.push(new_record);
      }
    }
  }
}

const design = +(File.readFileSync("input.txt", "utf-8").trim());


{
  const start = {x: 1, y: 1, z: design};
  const goal = {x: 31, y: 39, z: design};
  const heuristic_for = (state) => heuristic(state, goal);

  for (let record of a_star(start, neighbors_of, to_hash, heuristic_for)) {
    if (record.hash === to_hash(goal)) {
      console.log("Part One: " + record.steps);
      break;
    }
  }
}

{
  const start = {x: 1, y: 1, z: design};
  const heuristic_for = (state) => 0;

  let count = 0;
  for (let record of a_star(start, neighbors_of, to_hash, heuristic_for)) {
    if (record.steps > 50) break;
    count += 1;
  }

  console.log("Part Two: " + count);
}
