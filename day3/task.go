package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func readInput() []string {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var inputLines []string
	for scanner.Scan() {
		inputLines = append(inputLines, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	return inputLines
}

func main() {
	task1()
}

func countTree(slope slope, christmasMap []string) int {
	treeCount := 0
	currX := 0
	for i := 0; i < len(christmasMap); i += slope.down {
		if christmasMap[i][currX] == '#' {
			treeCount++
		}
		currX = (currX + slope.right) % len(christmasMap[0])
	}
	return treeCount
}

type slope struct {
	down  int
	right int
}

func task1() {
	var christmasMap = readInput()
	slope := slope{1, 3}
	fmt.Println("Task1 solution: " + strconv.Itoa(countTree(slope, christmasMap)))
}
