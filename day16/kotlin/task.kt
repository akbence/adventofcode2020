import java.nio.file.Files
import java.nio.file.Paths
import java.util.*
import kotlin.collections.ArrayList


var namedRanges : TreeMap<String,SortedMap<Int,Int>> = TreeMap(TreeMap())
var nearbyTickets : ArrayList<List<Int>> = ArrayList()
var nearbyValidTickets : ArrayList<List<Int>> = ArrayList()
var nameAndListTable : TreeMap<String, ArrayList<Boolean?>> = TreeMap()
var myTicket : ArrayList<Int> = ArrayList()

fun main() {
    readInput()
    println("Task1 solution: "+ task1())
    println("Task2 solution: "+ task2())
}

fun task1(): Int {
    var ticketScanningErrorRate = 0
    val potentialMap = TreeMap<Int,Int>()
    for ( map in namedRanges.values){
        for ((k,v) in map){
            potentialMap.put(k,v);
        }
    }
    for (ticket in nearbyTickets){
        var validTicket = true
        for (ticketValue in ticket){
            var valid = false
            for ((min,max) in potentialMap){
                if(ticketValue in min..max){
                    valid = true
                }
            }
            if(!valid){
                validTicket=false;
                ticketScanningErrorRate += ticketValue
            }
        }
        if(validTicket){
            nearbyValidTickets.add(ticket)
        }
    }
    return ticketScanningErrorRate
}

fun task2(): Long {

    for (str in namedRanges.keys){
        var array = arrayListOf<Boolean?>()
        for (i in 0..(namedRanges.size-1)){
            array.add(true);
        }
        nameAndListTable.put(str, array)
    }

    for (ticket in nearbyValidTickets){
        var counter = 0;
        for (ticketValue in ticket){
            for ((key,map) in namedRanges){
                var valid = false
                for ((min,max) in map){
                    if(ticketValue in min..max){
                        valid =  true
                    }
                }
                if(!valid){
                    nameAndListTable.get(key)?.set(counter, false)
                }
            }
            counter++
        }
    }

    var notReady = true;
    var orderedNames = arrayOfNulls<String>(nameAndListTable.size)
    while(notReady){
        var lastFound=-1
        for((name,values) in nameAndListTable){
            if (values.stream().filter { b -> b == true }.count() == 1L )
            {
                for (iterator in 0..(nameAndListTable.size-1)){
                    if(values[iterator] == true){
                        orderedNames.set(iterator,name)
                        lastFound=iterator;
                    }
                }
            }
        }
        for((_,values) in nameAndListTable){
            if(lastFound != -1)
            values[lastFound] = false;
        }
        if(lastFound == -1){
            notReady=false;
        }
    }

    var iterator = 0
    var result:Long = 1L;
    for (name in orderedNames){
        if(name?.startsWith("departure")!!){
            result *= myTicket.get(iterator);
        }
        iterator++
    }

    return result
}
fun checkState(line: String?, p: Int): Int {
    var phase = p
    if(line.equals("")){
        phase++
    }
    return phase;
}

fun readInput(){
    val lines = Files.readAllLines(Paths.get("../input.txt"))
    var phase = 1
    for (line in lines) {
        phase = checkState(line, phase)
        if(phase == 1){
            val splittedLine = line.split(":")
            val firstPart = splittedLine[0].trim()
            val secondPart = splittedLine[1].split("or")
            var rangedMap :TreeMap <Int,Int> =  TreeMap()
            for (range in secondPart){
                val nums = range.trim().split("-")
                rangedMap.put(nums[0].toInt(),nums[1].toInt())
            }
            namedRanges.put(firstPart,rangedMap)
        }
        if(phase == 2 && !line.equals("") && !line.equals("your ticket:")){
            val ticketValues= line.trim().split(",")
            for (value in ticketValues){
                myTicket.add(value.toInt())
            }

        }
        if(phase == 3 && !line.equals("") && !line.equals("nearby tickets:")){
            val ticketValues= line.trim().split(",")
            val valueList = ticketValues.toList().map { s : String -> s.toInt() }
            nearbyTickets.add(valueList)
        }
    }
}