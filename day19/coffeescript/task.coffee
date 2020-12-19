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
            
validateRule = (rule, message, index, rulesProcessed) ->
    console.log("current rule ", rule)
    if rulesProcessed >= 2000
        return [false, index]
    if index == message.length
        return [false, index]
    prevIndex = index
    for ruleSeq in rules[rule]
        index = prevIndex
        values = ruleSeq.split(" ")
        if values[0][1] == "a" || values[0][1] == "b"
            return [values[0][1] == message[index], index + 1]
        isValid = true
        for v in values
            [validRule, index] = validateRule(v, message, index, rulesProcessed + 1)
            if !validRule
                isValid = false
                break
        if isValid
            console.log(values)
            return [true, index]
    return [false, index]

    

readInput()
console.log(validateRule(0, "babbbbaabbbbbabbbbbbaabaaabaaa", 0, 0))
validMessages = 0
"
for message in messages
    [bool, charLength] = validateRule(0, message, 0, 0)
    if bool && charLength == message.length
        validMessages += 1

console.log(validMessages)
"
