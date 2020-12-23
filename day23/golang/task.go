package main

import (
	"bufio"
	"container/list"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
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

func getMaxValue(numbers *list.List) int {
	var maxValue int
	maxValue = -1
	for el := numbers.Front(); el != nil; el = el.Next() {
		if el.Value.(int) > maxValue {
			maxValue = el.Value.(int)
		}
	}
	return maxValue
}

func getMinValue(numbers *list.List) int {
	var lowestValue int
	lowestValue = 10000001
	for el := numbers.Front(); el != nil; el = el.Next() {
		if el.Value.(int) < lowestValue {
			lowestValue = el.Value.(int)
		}
	}
	return lowestValue
}

func getValueIterator(li *list.List, value int) *list.Element {
	for el := li.Back(); el != nil; el = el.Prev() {
		if el.Value == value {
			return el
		}
	}
	return nil
}

func getDestination(numbers *list.List, currentCup int, minValue int, maxValue int, c1 int, c2 int, c3 int, positions *map[int]*list.Element) *list.Element {
	searchedNumber := currentCup
	for {
		for {
			if searchedNumber == minValue {
				searchedNumber = maxValue
			} else {
				searchedNumber--
			}
			if searchedNumber != c1 && searchedNumber != c2 && searchedNumber != c3 {
				break
			}
		}
		el := (*positions)[searchedNumber]
		return el
	}

	return nil
}

func doRounds(numbers *list.List, rounds int) {
	positions := make(map[int]*list.Element, 10000000)
	for el := numbers.Front(); el != nil; el = el.Next() {
		positions[el.Value.(int)] = el
	}
	minValue := getMinValue(numbers)
	maxValue := getMaxValue(numbers)
	for i := 0; i < rounds; i++ {
		currentCup := numbers.Front()
		nextCup1 := numbers.Remove(currentCup.Next()).(int)
		nextCup2 := numbers.Remove(currentCup.Next()).(int)
		nextCup3 := numbers.Remove(currentCup.Next()).(int)
		destination := getDestination(numbers, currentCup.Value.(int), minValue, maxValue, nextCup1, nextCup2, nextCup3, &positions)
		newCup3 := numbers.InsertAfter(nextCup3, destination)
		newCup2 := numbers.InsertAfter(nextCup2, destination)
		newCup1 := numbers.InsertAfter(nextCup1, destination)
		positions[nextCup3] = newCup3
		positions[nextCup2] = newCup2
		positions[nextCup1] = newCup1
		numbers.MoveToBack(currentCup)
	}
}

func task1() string {
	strNums := strings.Split(readInput()[0], "")
	numbers := list.New()
	for _, n := range strNums {
		i, err := strconv.Atoi(n)
		if err != nil {
			panic(err)
		}
		numbers.PushBack(i)
	}

	doRounds(numbers, 100)
	e := numbers.Front()
	for e.Value != 1 {
		numbers.MoveToBack(e)
		e = numbers.Front()
	}

	res := ""
	for el := numbers.Front().Next(); el != nil; el = el.Next() {
		res = res + strconv.Itoa(el.Value.(int))
	}

	return res
}

func task2() string {
	strNums := strings.Split(readInput()[0], "")
	numbers := list.New()
	for _, n := range strNums {
		i, err := strconv.Atoi(n)
		if err != nil {
			panic(err)
		}
		numbers.PushBack(i)
	}
	maxValue := getMaxValue(numbers)
	for i := maxValue + 1; i <= 1000000; i++ {
		numbers.PushBack(i)
	}

	doRounds(numbers, 10000000)
	e := numbers.Front()
	for e.Value != 1 {
		numbers.MoveToBack(e)
		e = numbers.Front()
	}

	return strconv.Itoa(e.Next().Value.(int) * e.Next().Next().Value.(int))
}

func main() {
	fmt.Println("Task1 solution: " + task1())
	fmt.Println("Task2 solution: " + task2())
}
