// Learn more about F# at http://fsharp.org

open System
open System.IO
open System.Collections.Generic

let filePath = "..\..\..\..\..\input.txt"
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

let rec dictionaryLineProcessor dictionary element_list =
    match element_list with
    | a::tail ->
        let new_dict = dictionaryProcessor (dictionary, a)
        dictionaryLineProcessor new_dict tail
    | [] -> dictionary

let validate (passport:Dictionary<string,string>) = 
    let found, value = passport.TryGetValue "pid"
    passport.ContainsKey "byr" &&
    passport.ContainsKey "iyr" &&
    passport.ContainsKey "eyr" &&
    passport.ContainsKey "hgt" &&
    passport.ContainsKey "hcl" &&
    passport.ContainsKey "ecl" &&
    passport.ContainsKey "pid"

let validate2 (passport:Dictionary<string,string>) = 
    true

let countValid pred passports = 
    passports |> List.filter pred |> List.length

let rec parsePassportsHelper lines passports actual_passport = 
    match lines with
    | [] -> passports |> List.append [actual_passport]
    | line::tail ->
        match line with
        | "" ->
            let dict = Dictionary<string, string>()
            parsePassportsHelper tail (List.append passports [actual_passport]) dict
        | _ ->
        let new_passport = dictionaryLineProcessor actual_passport (line.Split(" ") |> Array.toList)
        parsePassportsHelper tail passports new_passport

let parsePassports lines = 
    let dict = Dictionary<string, string>()
    parsePassportsHelper lines [] dict

let task1 lines =
    lines |> parsePassports |> countValid validate

let task2 lines =
    lines |> parsePassports |> List.filter validate |> countValid validate2

[<EntryPoint>]
let main argv =
    let lines = readLines |> Seq.toList
    printfn "Task1 solution: %d" (task1 lines)
    printfn "Task2 solution: %d" (task2 lines)
    System.Console.ReadKey true
    0

