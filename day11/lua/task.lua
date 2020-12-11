read_file = function (path)
  local file = io.open(path, "rb") 
  if not file then return nil end

  local lines = {}

  for line in io.lines(path) do
    local row = {}
    for c in string.gmatch(line, ".") do
      if c ~= "\n" then
        table.insert(row, c)
      end
    end
    table.insert(row, 1, "F")
    table.insert(row, "F") 
    table.insert(lines, row)
  end

  file:close()
  return lines;
end

seats = read_file("../input.txt")
local row = {} 
for i = 1, #seats[1] do
  table.insert(row, "F")
end
table.insert(seats, 1, row)
table.insert(seats, row)

local seats2 = {}
for row = 1,#seats do
  table.insert(seats2, {table.unpack(seats[row])})
end


function nextSeats1(seats)
  local changed = false
  newSeats = {}
  for row = 1,#seats do
    table.insert(newSeats, {table.unpack(seats[row])})
  end

  local ds = {{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}}

  for i = 2,#seats - 1 do
    for j = 2,#seats[i] - 1 do
      local occupied_count = 0
      for _, v in pairs(ds) do
        dr = v[1]
        dc = v[2]
        if seats[i + dr][j + dc] == "#" then
          occupied_count = occupied_count + 1
        end
      end

      if seats[i][j] == "L" and occupied_count == 0 then
        changed = true
        newSeats[i][j] = "#"
      elseif seats[i][j] == "#" and occupied_count >= 4 then
        changed = true
        newSeats[i][j] = "L"
      end
    end
  end

  return {newSeats, changed}
end


function nextSeats2(seats)
  local changed = false
  newSeats = {}
  for row = 1,#seats do
    table.insert(newSeats, {table.unpack(seats[row])})
  end

  local ds = {{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}}

  for i = 2,#seats - 1 do
    for j = 2,#seats[i] - 1 do
      local occupied_count = 0
      for _, v in pairs(ds) do
        dr = v[1]
        dc = v[2]
        rr = i + dr
        cc = j + dc
        while seats[rr][cc] == "." do
          rr = rr + dr
          cc = cc + dc
        end
        if seats[rr][cc] == "#" then
          occupied_count = occupied_count + 1
        end
      end

      if seats[i][j] == "L" and occupied_count == 0 then
        changed = true
        newSeats[i][j] = "#"
      elseif seats[i][j] == "#" and occupied_count >= 5 then
        changed = true
        newSeats[i][j] = "L"
      end
    end
  end

  return {newSeats, changed}
end



function task1(seats)
  local changed = true
  while changed do
    local nextS = nextSeats1(seats)
    seats = nextS[1]
    changed = nextS[2]
  end
  return seats
end

function task2(seats)
  local changed = true
  while changed do
    local nextS = nextSeats2(seats)
    seats = nextS[1]
    changed = nextS[2]
  end
  return seats
end

function countSeats(seats)
  local count = 0
  for _, r in pairs(seats) do
    for _, c in pairs(r) do
      if c == "#" then
        count = count + 1
      end
    end
  end
  return count
end

local task1_answer = countSeats(task1(seats))
local task2_answer = countSeats(task2(seats2))
print("Task1 solution: " .. task1_answer)
print("Task2 solution: " .. task2_answer)
