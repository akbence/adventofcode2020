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


function nextSeats(seats)
  local changed = false
  newSeats = {}
  for row = 1,#seats do
    table.insert(newSeats, {table.unpack(seats[row])})
  end

  local ds = {{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}} -- directions, nem de az csak plusz 1 ciklus

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

local changed = true

while changed do
  local nextS = nextSeats(seats)
  seats = nextS[1]
  changed = nextS[2]
end

local task1_answer = 0
for _, r in pairs(seats) do
  for _, c in pairs(r) do
    if c == "#" then
      task1_answer = task1_answer + 1
    end
  end
end

for i = 1,#seats do
  local row = table.concat(seats[i], "")
  print(row)
end
print(task1_answer)