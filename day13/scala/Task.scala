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

        var firstElement = busIdArray(0).toLong
        var maxElement = busIdArray.sorted(Ordering.Long.reverse)(0).toLong
        var maxElement2 = busIdArray.sorted(Ordering.Long.reverse)(1).toLong
        var notFound = true
        var maxElementOffset:Long = map.getOrElse(default = 0L, key = maxElement)
        var maxElementOffset2:Long = map.getOrElse(default = 0L, key = maxElement2)
        var counter = 1L;
        println(maxElement +" " + maxElementOffset )
        println(firstElement +" ")
        while(((maxElement2*counter) -maxElementOffset2 + maxElementOffset) % maxElement != 0){
            //println(firstElement*counter)
            counter +=1
        }
        println("counter: "+ counter)
        var actualTimeStamp:Long = (maxElement2*counter) - maxElementOffset2
        while(notFound){
            var localCheck = true
            println("ACTUAL: "+ actualTimeStamp)
            for ((busid, offset) <- map){
                if((actualTimeStamp + offset)%busid != 0){
                    localCheck=false
                }
            }
            if(localCheck){
                notFound=false;
            }
            else{
                actualTimeStamp += maxElement2 * maxElement
            }

            // if( actualTimeStamp >= 4000){
            //     notFound=false
            // }
        }
        actualTimeStamp
    }
    
    def main(args: Array[String]) = {
        var lines = getInput()
        println("Task1 solution: "+ task1(lines))
        println("Task2 solution: "+ task2(lines))
    }
}