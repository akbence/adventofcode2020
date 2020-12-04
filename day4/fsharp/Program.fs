// Learn more about F# at http://fsharp.org

open System
open System.IO
open System.Collections.Generic
open System.Text.RegularExpressions

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
    passport.ContainsKey "byr" &&
    passport.ContainsKey "iyr" &&
    passport.ContainsKey "eyr" &&
    passport.ContainsKey "hgt" &&
    passport.ContainsKey "hcl" &&
    passport.ContainsKey "ecl" &&
    passport.ContainsKey "pid"

let regexValidator pattern str = 
    let m = Regex(pattern).Match(str)
    m.Success

let validateyear min max (year: string) =
    match Int32.TryParse year with
    | (true, year) -> year >= min && year <= max
    | (false, _) -> false
    
let (|ParseRegex|_|) regex str =
   let m = Regex(regex).Match(str)
   if m.Success
   then Some (List.tail [ for x in m.Groups -> x.Value ])
   else None

let validateHGT hgt = 
    match hgt with
    | ParseRegex "^(\d+)(cm|in)$" [value; m] ->
        match Int32.TryParse value with
        | (true, value) -> 
            match m with
            | "cm" -> 150 <= value && value <= 193
            | "in" -> 59 <= value && value <= 76
            | _ -> false
        | (false, _) -> false
    | _ -> false

let validate2 (passport:Dictionary<string,string>) = 
    let _, byr = passport.TryGetValue "byr"
    let _, iyr = passport.TryGetValue "iyr"
    let _, eyr = passport.TryGetValue "eyr"
    let _, hgt = passport.TryGetValue "hgt"
    let _, hcl = passport.TryGetValue "hcl"
    let _, ecl = passport.TryGetValue "ecl"
    let _, pid = passport.TryGetValue "pid"
    let byr = validateyear 1920 2002 byr
    let iyr = validateyear 2010 2020 iyr
    let eyr = validateyear 2020 2030 eyr

    let hcl = regexValidator "^#[a-f0-9]{6}$" hcl
    let ecl = regexValidator "^(amb|blu|brn|gry|grn|hzl|oth)$" ecl
    let pid = regexValidator "^\d{9}$" pid
    let hgt = validateHGT hgt

    byr && eyr && iyr && hcl && ecl && pid && hgt

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


