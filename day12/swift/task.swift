import Foundation

let filename = "input.txt" //this is the file. we will write to and read from it

let dir = URL(fileURLWithPath: ".")
let fileURL = dir.deletingLastPathComponent().appendingPathComponent(filename)
let file = try String(contentsOf: fileURL, encoding: .utf8)

let lines = file.split(separator: "\n").map({String($0)})

func task1(lines: [String]) -> Int {
  var lon = 0
  var lat = 0
  var facing = 0
  let turnOrder = ["E", "S", "W", "N"]
  for line in lines {
    var d = String(line.first!)
    let steps = Int(line.dropFirst())!
    if d == "L" {
      facing = ((4 + facing) - (Int(steps / 90))) % 4
    }
    if d == "R" {
      facing = (facing + (Int(steps / 90))) % 4
    }
    if d == "F" {
      d = turnOrder[facing]
    }
    if d == "N" {
      lat += steps
    }
    if d == "S" {
      lat -= steps
    }
    if d == "E" {
      lon += steps
    }
    if d == "W" {
      lon -= steps
    }
  }

  return abs(lon) + abs(lat)
}

func task2(lines: [String]) -> Int {
  var pos = [0, 0]
  var wp = [10, 1]
  for line in lines {
    let d = String(line.first!)
    let steps = Int(line.dropFirst())!
    if d == "N" {
      wp[1] += steps
    }
    if d == "S" {
      wp[1] -= steps
    }
    if d == "E" {
      wp[0] += steps
    }
    if d == "W" {
      wp[0] -= steps
    }
    if d == "F" {
      pos[0] += wp[0] * steps
      pos[1] += wp[1] * steps
    }
    if d == "L" {
      for _ in 1...(steps / 90) {
        let lat = -wp[1]
        let lon = wp[0]
        wp = [lat, lon]
      }
    }
    if d == "R" {
      for _ in 1...(steps / 90) {
        let lat = wp[1]
        let lon = -wp[0]
        wp = [lat, lon]
      }
    }
  }
  return abs(pos[0]) + abs(pos[1])
}

print("Task1 solution: \(task1(lines: lines))")
print("Task2 solution: \(task2(lines: lines))")