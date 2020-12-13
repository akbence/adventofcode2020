import scala.io.Source

object Task {

    def getInput() = {
        val filename = "../input.txt"
        val lines=Source.fromFile(filename).getLines.toArray
        lines
    }

    def task1(lines: Array[String]): Int = {
        var startTime = lines(0).toInt
        var busIdStringArray = lines(1).split(",")
        var busIdArray = busIdStringArray.filter(! _.contains("x")).map(_.toInt)
        var map:Map[Int,Int] =  Map()
        for (id <- busIdArray){
            var previousDepart = startTime - (startTime%id)
            var timeToNextDepart = previousDepart + id - startTime
            map += (id -> timeToNextDepart)
        }
        var minWaitElement = map.minBy(_._2)
        minWaitElement._1 * minWaitElement._2
    }
    
    def main(args: Array[String]) = {
        var lines = getInput()
        println("Task1 solution: "+ task1(lines))
    }
}