package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func readInput() []string {
	file, err := os.Open("../input.txt")
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
	task2()
}

func countTree(slope Slope, christmasMap []string) int {
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

type Slope struct {
	down  int
	right int
}

func task1() {
	var christmasMap = readInput()
	slope := Slope{1, 3}
	fmt.Println("Task1 solution: " + strconv.Itoa(countTree(slope, christmasMap)))
}

func task2() {
	var christmasMap = readInput()
	slopes := []Slope{
		{1, 1},
		{1, 3},
		{1, 5},
		{1, 7},
		{2, 1},
	}
	mult := 1
	for _, slope := range slopes {
		mult *= countTree(slope, christmasMap)
	}
	fmt.Println("Task2 solution: " + strconv.Itoa(mult))
}
