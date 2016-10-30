const File = require("fs");

function all(arr, pred) {
  for (let x of arr) {
    if (!pred(x)) {
      return false;
    }
  }
  return true;
}

function get(vars, name) {
  if (!isNaN(parseInt(name, 10))) {
  // Handle literals directly
    return parseInt(name, 10);
  } else {
    return vars[name];
  }
}


const GATE_OPS = {
  "": (([x]) => x),
  "NOT": (([x]) => 65535 - x),
  "LSHIFT": (([lhs, rhs]) => (lhs << rhs) & 0xFFFF),
  "RSHIFT": (([lhs, rhs]) => lhs >> rhs),
  "AND": (([lhs, rhs]) => lhs & rhs),
  "OR": (([lhs, rhs]) => lhs | rhs),
};


function parse_gates(lines) {
  const rex = /([a-z0-9]*)\s*(AND|OR|NOT|LSHIFT|RSHIFT|)\s*\b([a-z0-9]+) -> ([a-z]+)/;

  const gates = [];
  for (let line of lines) {
    const result = rex.exec(line);

    gates.push({
      label: result[2],
      args: [result[1], result[3]].filter(x => !!x),
      target: result[4]
    });
  }

  return gates;
}

function run_gates(gates) {
  const wires = {};
  while (gates.length > 0) {
    const gate = gates.splice(0, 1)[0];

    let args = gate.args.map(name => get(wires, name));
    if (!all(args, x => x != undefined)) {
      gates.push(gate);
      continue;
    }

    wires[gate.target] = GATE_OPS[gate.label](args);
  }

  return wires;
}

const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const gates = parse_gates(lines);

const wires_1 = run_gates([...gates]);
console.log("Part One: " + wires_1["a"]);

gates.filter(gate => gate.target === "b")[0].args[0] = ""+wires_1["a"];
const wires_2 = run_gates([...gates]);
console.log("Part Two: " + wires_2["a"]);
