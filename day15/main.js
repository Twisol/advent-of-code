const File = require("fs");


function scoreOf(ingredients, recipe) {
  let product = 1;
  for (let facet of ["capacity", "durability", "flavor", "texture"]) {
    let sum = 0;
    for (let name of Object.keys(recipe)) {
      sum += ingredients[name][facet] * recipe[name];
    }

    product *= Math.max(sum, 0);
  }

  return product;
}

function caloriesFor(ingredients, recipe) {
  let calories = 0;
  for (let name of Object.keys(recipe)) {
    calories += ingredients[name].calories * recipe[name];
  }

  return calories;
}

function* recipes(ingredients, max) {
  if (ingredients.length === 1) {
    yield {[ingredients[0].name]: max};
  } else {
    for (let i = 0; i <= max; ++i) {
      for (let recipe of recipes(ingredients.slice(1), max - i)) {
        yield Object.assign({[ingredients[0].name]: i}, recipe);
      }
    }
  }
}

function parse_ingredients(lines) {
  const rex = /([^:]+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/;

  const ingredients = {};
  for (let line of lines) {
    const match = rex.exec(line);
    ingredients[match[1]] = {
      name: match[1],
      capacity: +match[2],
      durability: +match[3],
      flavor: +match[4],
      texture: +match[5],
      calories: +match[6],
    };
  }

  return ingredients;
}

const lines = File.readFileSync("input.txt", "utf-8").trim().split("\n");
const ingredients = parse_ingredients(lines);

let best_recipe = {recipe: null, score: 0};
let caloric_recipe = {recipe: null, score: 0};
for (let recipe of recipes(Object.values(ingredients), 100)) {
  const score = scoreOf(ingredients, recipe);
  const calories = caloriesFor(ingredients, recipe);

  if (score >= best_recipe.score) {
    best_recipe = {recipe, score};
  }

  if (calories == 500 && score >= caloric_recipe.score) {
    caloric_recipe = {recipe, score};
  }
}

console.log("Part One: " + best_recipe.score);
console.log("Part Two: " + caloric_recipe.score);
