$lines = Get-Content "../input.txt"

function countTree {
  param (
    [Parameter()]
    [int]$slopeY,
    [Parameter()]
    [int]$slopeX,
    [Parameter()]
    $lines
  )
  $treeCount = 0
  $currX = 0
  for ($i = 0; $i -lt $lines.length; $i = $i + $slopeY) {
    if ($lines[$i][$currX] -eq "#") {
      $treeCount = $treeCount + 1
    }
    $currX = ($currX + $slopeX) % $lines[0].length
  }
  return $treeCount
}

function task1($lines) {
  return countTree 1 3 $lines
}

function task2($lines) {
  $slopes = @(@(1, 1), @(1, 3), @(1, 5), @(1, 7), @(2, 1))
  $mult = 1
  foreach($slope in $slopes) {
    $mult = $mult * (countTree $slope[0] $slope[1] $lines)

  }
  return $mult
}

echo "Task1 solution: $(task1($lines))"
echo "Task2 solution $(task2($lines))"