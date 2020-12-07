
// file read
int readFileLineByLine(String filePath) {
    File file = new File(filePath)
    def line, noOfLines = 0;
    file.withReader { reader ->
        while ((line = reader.readLine()) != null) {
            println "${line}"
            noOfLines++
        }
    }
    return noOfLines
}

class Tree{
    def color = String 
    def additionalBags = []
    def actual = Tree

    static Tree startTree(){
        Tree tree = new Tree();
        tree.actual = tree;
        tree.additionalBags = []
        tree.color = "ROOT";
        return tree
    }

}

class ColoredNumberedBag{
    def color = String
    def quantity = int
}

Tree buildTree(Tree tree, ColoredNumberedBag[] list){

}

def parseLine(String line){
    def words = [];
    words = line.split()
    println(words)
    for (word in words) {
        println(word)
    }
    def pattern = ~/(\d+) (\w+ \w+) bag/
    def matches = line.findAll(pattern)
    println (matches)
    //println(words.length())

}


//Main
Tree tree = Tree.startTree()
new File("../input.txt").withReader('UTF-8') { reader ->
def line
    while ((line = reader.readLine()) != null) {
        def mytree= new Tree(); 
        println "${line}"
        parseLine(line)
    }
}
