<?php
  function readLines() {
    $lines = array();
    if ($file = fopen("../input.txt", "r")) {
        while(!feof($file)) {
            $line = fgets($file);
            array_push($lines, $line);
        }
        fclose($file);
    }
    return $lines;
  }

  function task1($lines) {
    $memories = array();
    foreach ($lines as $i => $line) {
      if (str_starts_with($line, "mask")) {
        $mask = explode(" ", $line)[2];
        $ormask = intval(str_replace("X", "0", $mask), 2);
        $andmask = intval(str_replace("X", "1", $mask), 2);
        continue;
      }
      preg_match('/mem\[(\d+)\] = (\d+)/', $line, $matches);
      $memories[$matches[1]] = ($matches[2] & $andmask) | $ormask;
    }

    $s = 0;
    foreach ($memories as $i => $m) {
      $s += $m;
    }
    return $s;
  }

  function createMasks($line) {
    $masks = array();
    $base = intval(str_replace("X", "0", $line), 2);
    $floatingMasks = array(str_replace("0", "F", $line));
    while(str_contains($floatingMasks[0], "X")) {
      $m = array_shift($floatingMasks);
      $m1 = preg_replace('/X/', "0", $m, 1);
      $m2 = preg_replace('/X/', "1", $m, 1);
      array_push($floatingMasks, $m1);
      array_push($floatingMasks, $m2);
    }
    foreach ($floatingMasks as $i => $m) {
      $orMask = intval(str_replace("F", "0", $m), 2);
      $andMask = intval(str_replace("F", "1", $m), 2);
      array_push($masks, array($orMask | $base, $andMask | $base));
    }

    return $masks;
  }

  function task2($lines) {
    $memories = array();
    foreach ($lines as $i => $line) {
      if (str_starts_with($line, "mask")) {
        $mask = explode(" ", $line)[2];
        $masks = createMasks($mask);
        continue;
      }
      preg_match('/mem\[(\d+)\] = (\d+)/', $line, $matches);
      foreach ($masks as $i => $m) {
        $addr = ($matches[1] & $m[1]) | $m[0];
        $memories[$addr] = $matches[2];
      }
    }

    $s = 0;
    foreach ($memories as $i => $m) {
      $s += $m;
    }


    return $s;
  }

  $lines = readLines();
  echo "Task1 solution: " . task1($lines) . "\n";
  echo "Task2 solution: " . task2($lines) . "\n";
?>