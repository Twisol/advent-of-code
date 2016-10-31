const File = require("fs");

function* map(gen, f) {
  for (let x of gen) {
    yield f(x);
  }
}

function* filter(gen, predicate) {
  for (let x of gen) {
    if (predicate(x)) yield x;
  }
}

function* take(gen, n) {
  let count = 0;
  for (let x of gen) {
    if (count >= n) break;

    count += 1;
    yield x;
  }
}

function* passwords(initial) {
  const alphabet = "abcdefghijklmnopqrstuvwxyz".split("");

  let password = [...initial];
  while (true) {
    for (let i = password.length - 1; i >= 0; --i) {
      password[i] = alphabet[(alphabet.indexOf(password[i]) + 1) % alphabet.length];
      if (password[i] !== "a") {
        break;
      }
    }
    yield password;
  }
}

function is_valid(password) {
  // this is gross.
  const increasing = /abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz/;
  const forbidden = /[iol]/;
  const double_letters = /(([a-z])\2).*((?!\1)[a-z])\3/;  // what have i wrought

  if (!increasing.exec(password)) {
    return false;
  } else if (forbidden.exec(password)) {
    return false;
  } else if (!double_letters.exec(password)) {
    return false;
  }

  return true;
}


const start = File.readFileSync("input.txt", "utf-8").trim().split("");

const new_passwords = [...take(filter(map(passwords(start), x => x.join("")), is_valid), 2)];

console.log("Part One: " + new_passwords[0]);
console.log("Part Two: " + new_passwords[1]);
