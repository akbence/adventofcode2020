
// file read
int readFileLineByLine(String filePath) {
    File file = new File(filePath)
    def line, noOfLines = 0;
    file.withReader { reader ->
        while ((line = reader.readLine()) != null) {
            noOfLines++
        }
    }
    return noOfLines
}

class Bag{
    def id
    def children
    def parents = []

    Bag(id, children) {
        this.id = id
        this.children = children
        this.parents = []
    }
}

class ColoredNumberedBag{
    def color = String
    def quantity = int
}

def parseLine(String line, Map bags){
    def id = line.split(" bags contain ")[0]
    def pattern = ~/(\d+) (\w+ \w+) bag/
    def matches = pattern.matcher(line)
    def children = [];
    for (match in matches) {
        children.add([match[1], match[2]])
    }

    bags[id] = new Bag(id, children)
}


//Main
def bags = [:]
new File("../input.txt").withReader('UTF-8') { reader ->
def line
    while ((line = reader.readLine()) != null) {
        parseLine(line, bags)
    }
}

for (bag in bags) {
    def children = bag.value.children
    for (child in children) {
        bags[child[1]].parents.add(bag.key)
    }
}

def collect_ancestor(id, bags) {
  Set parents = bags[id].parents
  for (parent in bags[id].parents) {
    parents = parents.plus(collect_ancestor(parent, bags))
  }
  return parents
}

def descendant_count(id, bags) {
  def children = bags[id].children
  def sum = 0
  for (child in children) {
      def count = child[0] as Integer
      sum = sum + (descendant_count(child[1], bags) * count)
      sum = sum + count
  }

  return sum
}


println("Task1 solution: " + collect_ancestor("shiny gold", bags).size())
println("Task2 solution: " + descendant_count("shiny gold", bags))