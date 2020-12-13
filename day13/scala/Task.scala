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

        var max1 = busIdArray.sorted(Ordering.Long.reverse)(0).toLong
        var max2 = busIdArray.sorted(Ordering.Long.reverse)(1).toLong
        var notFound = true
        var actualTimeStamp:Long = 19L-3L
        var testcntr= 0;
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
            actualTimeStamp += max1 * 17 //map.getOrElse(default = 0L, key = max2) //max1*max2
            testcntr +=1;

            if( actualTimeStamp >= 4000){
                notFound=false
            }
        }
        actualTimeStamp - 1
    }
    
    def main(args: Array[String]) = {
        var lines = getInput()
        println("Task1 solution: "+ task1(lines))
        println("Task2 solution: "+ task2(lines))
    }
}