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
  var deck1 = d1.slice();
  var deck2 = d2.slice();
  var round = 0
  var maxLen= deck1.length + deck2.length 
  while(!(deck1.length == maxLen || deck2.length == maxLen) && round < 20){
    round ++
    var card1 = deck1.shift()
    var card2 = deck2.shift()
    console.log("ROUND "+  round)
    console.log(deck1)
    console.log(deck2)
    console.log("p1 plays: " + card1)
    console.log("p2 plays: " + card2)
    winner = 0
    if (deck1.length >= card1 && deck2.length >= card2){
      console.log("SUB-GAME AT: " + round)
      winner = task2SubGame(deck1.slice(0,card1), deck2.slice(0,card2))
    }

    if(winner == 1){
      deck1.push(card1)
      deck1.push(card2)
    }else if(winner == 2){
      deck2.push(card2)
      deck2.push(card1)
    }else if(card1 > card2){
      deck1.push(card1)
      deck1.push(card2)
    }else if(card1 < card2){
      deck2.push(card2)
      deck2.push(card1)
    }
    console.log("GOING NEXT ROUND WITH: " + deck1 + "-" + deck2)
  }

  winningDeck = deck1.length == maxLen ? deck1 : deck2
  score = 0;
  for (let index = 0; index < maxLen; index++) {
    score += (maxLen-index) * winningDeck[index]
  }
  return score
}

function task2SubGame(d1,d2){
  var deck1 = d1.slice();
  var deck2 = d2.slice();
  var round = 0
  var maxLen= deck1.length + deck2.length
  while(!(deck1.length == maxLen || deck2.length == maxLen)){
    round ++
    var card1 = deck1.shift()
    var card2 = deck2.shift()

    console.log("SUB ROUND "+  round)
    console.log(deck1)
    console.log(deck2)
    console.log("p1 plays: " + card1)
    console.log("p2 plays: " + card2)

    winner = 0
    if (deck1.length >= card1 && deck2.length >= card2){
      winner = task2SubGame(deck1.slice(0,card1), deck2.slice(0,card2))
    }
    if(winner == 1){
      deck1.push(card1)
      deck1.push(card2)
      winner = 0
    }

    if(winner == 2){
      deck2.push(card2)
      deck2.push(card1)
      winner = 0
    }

    if(card1 > card2 && winner != 2){
      deck1.push(card1)
      deck1.push(card2)
    }
    
    if(card1 < card2 && winner != 1){
      deck2.push(card2)
      deck2.push(card1)
    }
    if (deck1.length == 0){
      winner = 2;
    }
    if (deck2.length == 0){
      winner = 1
    }

    if (winner != 0){
      console.log("FOUND WINNER: " + winner)
      return winner
    }

  }
  return deck1.length == maxLen ? 1 : 2
}

function XOR(a,b) {
  return ( a || b ) && !( a && b );
}

createDecks(input)
console.log("Task1 solution: "+ task1(d1,d2))
console.log("Task2 solution: "+ task2(d1,d2))
