fname = "../input.txt"
# using do means the file is closed automatically
# in the same way "with" does in python

dict = Dict{Int,Int}()
lastElement = 0
lastIndex = 0
open(fname,"r") do f
    for line in eachline(f)
        substring = split(line, ",")
        global lastIndex =length(substring)
        global lastElement = parse(Int,last(substring))
        for (n, f) in enumerate(substring)
            if n < length(substring) 
                key = parse(Int, f)
                dict[key]= n    
            end
        end
    end
end

f = open(fname,"r")

while lastIndex != 30000000
    if lastIndex == 2020
        println("Task1 solution: ", lastElement)
    end
    current = get(dict,lastElement,0)
    if current != 0
        current = lastIndex - current
    end
    dict[lastElement] = lastIndex
    global lastElement = current
    global lastIndex += 1
end
close(f)
println("Task2 solution: ", lastElement)