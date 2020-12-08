use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::vec::Vec;

fn main() {

    let mut vec = Vec::new();
    if let Ok(lines) = read_lines("../input.txt") {
        for line in lines {
            if let Ok(var) = line {
                //println!("{}", var);
                vec.push(var);
            }
        }
    }

    let mut visited = vec![false; vec.len()];

    for x in &vec {
        println!("{}", x);
        println!("{}",visited[8])
    }

    let mut accumulator =0;
    let mut curr_command =0;
    while visited[curr_command as usize] == false{
        let splitted=vec[curr_command as usize].split_whitespace();
        let split_vec = splitted.collect::<Vec<&str>>();
        //let argument=vec[curr_command].split_whitespace()[1];
        println!("{}",split_vec[0]);

        if split_vec[0] == "jmp"{
            let argument: i32 = split_vec[1].parse().unwrap();
            curr_command += argument-1;
        }
        if split_vec[0] == "acc"{
            let argument: i32 = split_vec[1].parse().unwrap();
            accumulator += argument;
        }
        visited[curr_command as usize] = true;
        curr_command+=1;
    }
    println!("Task1 solution: {}", accumulator);
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}