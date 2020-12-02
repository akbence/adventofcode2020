const fs = require('fs');

input = fs.readFileSync('./day2/input.txt', 'utf-8').split(/\r?\n/);

function parseLine(line) {
  const re = /(\d+)-(\d+) (.): (.+)/;

  result = line.match(re)

  return {
    "min": +result[1],
    "max": +result[2],
    "char": result[3],
    "password": result[4],
  }
}

function validate(record) {
  const charsCount = {}
  for(let i = 0; i < record.password.length; i++) {
    charsCount[record.password[i]] = charsCount[record.password[i]] + 1 || 1;
  }

  if (charsCount[record.char] >= record.min && charsCount[record.char] <= record.max) {
    return true;
  }

  return false;
}

function task1(input) {
  const validPasswodCount = input.map(parseLine).map(validate).reduce((a, c) => c ? a + 1 : a, 0)
  console.log(`Task1 solution: ${validPasswodCount}`)
}

task1(input)