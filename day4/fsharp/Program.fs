// Learn more about F# at http://fsharp.org

open System
open System.IO
open System.Collections.Generic

let filePath = "..\..\..\..\input.txt"
let readLines = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}


let dictionaryProcessor (dictionary: Dictionary<string, string>, element: string) =
    let parts = element.Split ":"
    let key = parts |> Seq.head
    let value = parts |> Seq.last
    dictionary.Add(key, value)
    dictionary

let dictionaryLineProcessor (dictionary: Dictionary<string, string>, element_list: seq<string>) =
    let mutable new_dict = dictionary
    for element in element_list do
        new_dict <- dictionaryProcessor (new_dict, element)
    new_dict


[<EntryPoint>]
let main argv =
    printfn "Hello World from F#!"
    let lines = readLines
    let mutable lista = Seq.empty
    let mutable dictionary: Dictionary<string, string> = Dictionary<string, string>()
    for line in lines do
        if line.Equals("") then
            printfn "%A" dictionary
            lista <- Seq.append lista dictionary
            printfn "%A" lista
            dictionary <- Dictionary<string, string>()
        else
            printfn "KAKAO 2"
            dictionary <- dictionaryLineProcessor (dictionary, line.Split " ")

    printfn "%A" (lista |> Seq.head)
    System.Console.ReadKey true
    0 // return an integer exit code

