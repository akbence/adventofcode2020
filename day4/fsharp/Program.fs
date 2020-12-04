// Learn more about F# at http://fsharp.org

open System
open System.IO

let filePath = "../input.txt"
let readLines = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
        
}



[<EntryPoint>]
let main argv =
    printfn "Hello World from F#!"
    let lines = readLines
    let splitted = lines |> Seq.head
    printfn "%A" (splitted.Split ' ')
    0 // return an integer exit code



