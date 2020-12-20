#Global vars
rules = {}
messages = []
#Read input
readInput = ->
    fs = require('fs')
    data = fs.readFileSync('../input.txt', 'UTF-8')

    lines = data.split(/\r?\n/)
    phase = 1
    for line in lines
        if line.length == 0
            phase++
        if phase == 1 && line.length != 0
            key = line.split(":")[0]
            val = line.split(": ")[1].split(" | ")
            rules[key] = val
        if phase == 2 && line.length != 0
            messages.push(line)

validateRules = (rulesToCheck, message) ->    
  validRules = []
  for ruleToCheck in rulesToCheck
    k = validateRule(ruleToCheck, message)
    validRules = validRules.concat(k)
  return validRules

validateRule = (rule, message) ->
  [ruleID, index] = rule
  if index == message.length
    return []

  prevIndex = index
  validRules = []
  for rule in rules[ruleID]
    index = prevIndex
    rs = rule.split(" ")

    if rs[0].length >= 2 and (rs[0][1] == "a" or rs[0][1] == "b")
      if rs[0][1] == message[index]
        return [[ruleID, index + 1]]
      return []

    vRules = validateRule([rs[0], index], message)
    for v in rs.slice(1)
      newVRules = []
      for r in vRules
        newVRules = newVRules.concat(validateRule([v, r[1]], message))
      vRules = newVRules
    validRules = validRules.concat(vRules)
  return validRules

readInput()

ans1 = messages.reduce (acc, message) ->
    ru = validateRules([['0', 0]], message)
    valid = ru.map((x) -> x[1] == message.length).reduce (a, curr) ->
        a || curr
    , false

    if valid
        return acc + 1
    acc
, 0

# Part two
rules['8'] = ['42', '42 8']
rules['11'] = ['42 31', '42 11 31']

ans2 = messages.reduce (acc, message) ->
    ru = validateRules([['0', 0]], message)
    valid = ru.map((x) -> x[1] == message.length).reduce (a, curr) ->
        a || curr
    , false

    if valid
        return acc + 1
    acc
, 0

console.log "Task1 solution: #{ans1}"
console.log "Task2 solution: #{ans2}"
