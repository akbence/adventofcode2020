import 'dart:async';
import 'dart:collection';
import 'dart:io';


void main() {
  var tileMap = processInput();
  print("Task1 solution: "+ task1(tileMap));
  print("Task2 solution: "+ task2(tileMap));

}

String task1(var tileMap){
    var count = 0;
    for(var b in tileMap.values){
      if(b % 2 != 0){
        count++;
      }
    }
    return count.toString();
}

String task2(HashMap<String,int> tileMap){
  
  for (var day = 1; day <=100; day++){
    var newTileMap = new HashMap<String,int>();
    tileMap = addSurroundingWhites(tileMap);
    for (var entry in tileMap.entries){
        var turnBlack  = isBecomeBlack(entry.key, tileMap);
        if(turnBlack){
          newTileMap[entry.key] = 1;
        }
    }
    tileMap = HashMap.from(newTileMap);    
  }
  return task1(tileMap);
}

HashMap<String, int> addSurroundingWhites(HashMap<String, int> tileMap) {
  HashMap<String, int> copyTileMap = HashMap.from(tileMap);
  for (var key in copyTileMap.keys){
    var coords= key.split(',');
    var a = int.parse(coords[0]);
    var b = int.parse(coords[1]);
    var c = int.parse(coords[2]);
    var value = null;
      //Check all adjecent
    value = copyTileMap[numsToCoord(a-1,b-1,c)];
    if( value == null ){
        tileMap[numsToCoord(a-1,b-1,c)] = 0;
    }
    
    value = copyTileMap[numsToCoord(a-1,b,c+1)];
    if( value == null ){
         tileMap[numsToCoord(a-1,b,c+1)] = 0;
    }
    value = copyTileMap[numsToCoord(a,b+1,c+1)];
    if( value == null ){
       tileMap[numsToCoord(a,b+1,c+1)] =0;
    }
    value = copyTileMap[numsToCoord(a+1,b+1,c)];
    if( value == null ){
         tileMap[numsToCoord(a+1,b+1,c)] = 0;
    }
    value = copyTileMap[numsToCoord(a+1,b,c-1)];
    if( value == null ){
         tileMap[numsToCoord(a+1,b,c-1)] = 0;
    }
    value = copyTileMap[numsToCoord(a,b-1,c-1)];
    if( value == null ){
        tileMap[numsToCoord(a,b-1,c-1)] = 0;
    }

  }
  return tileMap;
}

HashMap<String,int> processInput(){
  var tileMap = new HashMap<String,int>();
  var contents = new File('../input.txt').readAsLinesSync(); 
    for (String content in contents){
      tileMap = buildToMap(content,tileMap);
    }
    return tileMap;
}

bool isBecomeBlack(String coord, HashMap<String,int> tileMap){
  var coords = coord.split(',');
  var a = int.parse(coords[0]);
  var b = int.parse(coords[1]);
  var c = int.parse(coords[2]);
  var blackTiles = 0;
  var value = null;

  //Check all adjecent
  value = tileMap[numsToCoord(a-1,b-1,c)];
  if( value != null && value % 2 != 0){
      blackTiles++;
  }
  
  value = tileMap[numsToCoord(a-1,b,c+1)];
  if( value != null && value % 2 != 0){
      blackTiles++;
  }
  value = tileMap[numsToCoord(a,b+1,c+1)];
  if( value != null && value % 2 != 0){
      blackTiles++;
  }
  value = tileMap[numsToCoord(a+1,b+1,c)];
  if( value != null && value % 2 != 0){
      blackTiles++;
  }
  value = tileMap[numsToCoord(a+1,b,c-1)];
  if( value != null && value % 2 != 0){
      blackTiles++;
  }
  value = tileMap[numsToCoord(a,b-1,c-1)];
  if( value != null && value % 2 != 0){
      blackTiles++;
  }


  if (tileMap[coord] % 2 == 0 && blackTiles == 2){
    return true;
  }
  else if (tileMap[coord] % 2 != 0 && (blackTiles == 0 || blackTiles > 2)){
    return false;
  }
  return tileMap[coord] % 2 != 0;
}

String numsToCoord(int a, int b, int c) {
  return a.toString() + ',' + b.toString() + ',' + c.toString();
}


HashMap<String,int> buildToMap(String param, HashMap<String,int>tileMap){
  var a = 0;
  var b = 0;
  var c = 0;
  for(int i = 0 ; i<param.length; i++){
    if(param[i] == 'e'){
      a++;
      b++;
    }
    if(param[i] == 'w'){
      a--;
      b--;
    }
    if(param[i]=='s'){
      i++;
      if(param[i] == 'e'){
        a++;
        c--;
      }
      if(param[i] == 'w'){
        b--;
        c--;
      }
    }
    if(param[i]=='n'){
      i++;
      if(param[i] == 'e'){
        b++;
        c++;
      }
      if(param[i] == 'w'){
        a--;
        c++;
      }
    }
    if(tileMap[numsToCoord(a, b, c)] == null){
      tileMap[numsToCoord(a, b, c)] = 0;
    }
  }
  if(tileMap[numsToCoord(a, b, c)] == null){
      tileMap[numsToCoord(a, b, c)] = 1;
    }
  if(tileMap[numsToCoord(a, b, c)] != null){
      tileMap[numsToCoord(a, b, c)] = tileMap[numsToCoord(a, b, c)] +=1;
    }


  return tileMap;
}
