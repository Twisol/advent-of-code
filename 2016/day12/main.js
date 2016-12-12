const File = require("fs");

function execute(program, registers) {
  let pc = 0;
  while (pc < program.length) {
    const insn = program[pc];
    pc += 1;

    let match;
    if ((match = /cpy (-?\d+|[abcd]) ([abcd])/.exec(insn))) {
      if (match[1] in registers) {
        registers[match[2]] = registers[match[1]];
      } else {
        registers[match[2]] = +match[1];
      }
    } else if ((match = /inc ([abcd])/.exec(insn))) {
      registers[match[1]] += 1;
    } else if ((match = /dec ([abcd])/.exec(insn))) {
      registers[match[1]] -= 1;
    } else if ((match = /jnz (-?\d+|[abcd]) (-?\d+)/.exec(insn))) {
      if (match[1] in registers) {
        if (registers[match[1]] !== 0) pc += (+match[2]) - 1;
      } else {
        if (+match[1] !== 0) pc += (+match[2]) - 1;
      }
    }
  }

  return registers;
}

const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");

console.log("Part One: " + execute(lines, {a: 0, b: 0, c: 0, d: 0}).a);
console.log("Part Two: " + execute(lines, {a: 0, b: 0, c: 1, d: 0}).a);
