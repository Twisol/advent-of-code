const File = require("fs");


function parse_reindeer(lines) {
  const rex = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\./;

  const reindeer = {};
  for (let line of lines) {
    const match = rex.exec(line);

    reindeer[match[1]] = {
      name: match[1],
      speed: +match[2],
      fly_time: +match[3],
      rest_time: +match[4],
    };
  }

  return reindeer;
}

function race_reindeer(reindeer, end_time) {
  const stats = {};
  for (let deer of Object.values(reindeer)) {
    stats[deer.name] = {
      name: deer.name,
      speed: deer.speed,
      fly_time: deer.fly_time,
      rest_time: deer.rest_time,

      mode: "fly",
      time_left: deer.fly_time,
      distance: 0,
      points: 0,
    };
  }

  let best_distance = 0;
  for (let timer = 0; timer < end_time; ++timer) {
    for (let deer of Object.values(stats)) {
      if (deer.mode === "fly") {
        deer.distance += deer.speed;
        best_distance = Math.max(best_distance, deer.distance);
      }

      deer.time_left -= 1;
      if (deer.time_left <= 0) {
        if (deer.mode === "fly") {
          deer.mode = "rest";
          deer.time_left = deer.rest_time;
        } else if (deer.mode === "rest") {
          deer.mode = "fly";
          deer.time_left = deer.fly_time;
        }
      }
    }

    for (let deer of Object.values(stats)) {
      if (deer.distance === best_distance) {
        deer.points += 1;
      }
    }
  }

  return stats;
}


const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const reindeer = parse_reindeer(lines);

const end_time = 2503;
const results = race_reindeer(reindeer, end_time);

const furthest = Object.values(results).reduce((x, y) => (x.distance < y.distance) ? y : x);
const pointiest = Object.values(results).reduce((x, y) => (x.points < y.points) ? y : x);

console.log("Part 1: " + furthest.distance);
console.log("Part 2: " + pointiest.points);
