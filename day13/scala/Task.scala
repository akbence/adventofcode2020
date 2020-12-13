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

    def task2(lines: Array[String]): Long = {
        var busIdStringArray = lines(1).split(",")
        var busIdArray = busIdStringArray.filter(! _.contains("x")).map(_.toLong)
        var map:Map[Long,Long] =  Map()
        for (id <- busIdArray){
            var pos:Long = 0L
            for (stringId <- busIdStringArray){
                if(stringId.equals(id.toString())){
                    map += (id -> pos)
                }
                pos += 1L
            }
        }

        var actualTimeStamp:Long = 0L
        var currBusIdProduct:Long = 1L
        for (element <- busIdArray){
            var offset:Long = map.getOrElse(default = 0L, key = element)
            actualTimeStamp = calcNextTimestamp(actualTimeStamp, element, offset, currBusIdProduct)
            currBusIdProduct *= element
        }

        actualTimeStamp
    }

    def calcNextTimestamp(actual : Long, element: Long, offset: Long, currBusIdProduct: Long):Long = {
        var counter = 0L;
        while((actual + currBusIdProduct*counter + offset) %  element != 0){
            counter +=1
        }
        actual + currBusIdProduct*counter
    }
    
    def main(args: Array[String]) = {
        var lines = getInput()
        println("Task1 solution: "+ task1(lines))
        println("Task2 solution: "+ task2(lines))
    }
}