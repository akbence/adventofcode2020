const fs = require('fs');

const input = fs.readFileSync('../input.txt', 'utf-8').split(/\r?\n/).filter(x => x.length > 0);

var d1 = []
var d2 = []
var currplayer=0

function createDecks(input){
  input.forEach(line => {
    if (line.startsWith("Player")){
      currplayer++
    } else{
      if(currplayer == 1){
        d1.push(parseInt(line))
      }
      if(currplayer == 2){
        d2.push(parseInt(line))
      }
    }
  });

}

function task1(d1, d2) {
  deck1 = d1.slice();
  deck2 = d2.slice();
  var round = 0
  maxLen= deck1.length + deck2.length
  while(!(deck1.length == maxLen || deck2.length == maxLen)){
    round ++
    card1 = deck1.shift()
    card2 = deck2.shift()

    if(card1 > card2){
      deck1.push(card1)
      deck1.push(card2)
    }
    
    if(card1 < card2){
      deck2.push(card2)
      deck2.push(card1)
    }
  }
  winningDeck = deck1.length == maxLen ? deck1 : deck2
  score = 0;
  for (let index = 0; index < maxLen; index++) {
    score += (maxLen-index) * winningDeck[index]
  }
  return score
}

function task2(d1, d2) {
  var winner,de1,de2
  [de1,de2,winner] = recursiveCombat(d1,d2)
  var winningDeck = winner == 1 ? de1 : de2
  return winningDeck.reverse().map((d,i) => d*(i+1)).reduce((p,c) => p+c)
}


function signaller(deck1, deck2){
  return deck1.join(",") +"#"+deck2.join(",")
}

function round(d1,d2){
  var deck1 = d1.slice()
  var deck2 = d2.slice()
  var card1 = deck1.shift()
  var card2 = deck2.shift()
  var winner = 1;
  if (deck1.length < card1 || deck2.length < card2){
    winner = card1 > card2 ? 1 : 2
  } else {
    var a,b
    [a,b,winner] = recursiveCombat(deck1.slice(0,card1),deck2.slice(0,card2))
  }
  if (winner == 1 ){
    deck1.push(card1)
    deck1.push(card2)
  } else {
    deck2.push(card2)
    deck2.push(card1)
  }
  return [deck1,deck2,winner]
}

function recursiveCombat(d1,d2){
  var deck1 = d1.slice()
  var deck2 = d2.slice()
  var memory = new Map()
  while(!memory.has(signaller(deck1,deck2)) &&deck1.length !=0 && deck2.length !=0){
    memory.set(signaller(deck1,deck2),true)
    var a,b
    [a,b] = round(deck1,deck2)
    deck1 = a
    deck2 = b
  }
  var winner = 1
  if (deck1.length == 0){
    winner = 2
  }

  return [deck1,deck2,winner]
}


createDecks(input)
console.log("Task1 solution: "+ task1(d1,d2))
console.log("Task2 solution: "+ task2(d1,d2))