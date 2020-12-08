use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::vec::Vec;

fn task1(vec: &Vec<String>) -> i32 {
    let mut accumulator =0;
    let mut curr_command =0;
    let mut visited = vec![false; vec.len()];
    while !visited[vec.len()-1] && visited[curr_command as usize] == false {
        visited[curr_command as usize] = true;
        let splitted=vec[curr_command as usize].split_whitespace();
        let split_vec = splitted.collect::<Vec<&str>>();

        if split_vec[0] == "jmp"{
            let argument: i32 = split_vec[1].parse().unwrap();
            curr_command += argument-1;
        }
        if split_vec[0] == "acc"{
            let argument: i32 = split_vec[1].parse().unwrap();
            accumulator += argument;
        }
        curr_command+=1;
    }

    return accumulator;
}

fn task2(vec: &Vec<String>) -> i32 {
    let mut vec = vec.to_vec();
    let mut i = 0;

    while i < vec.len() {
        let prev_value = vec[i].to_string();
        let splitted=vec[i].split_whitespace();
        let split_vec = splitted.collect::<Vec<&str>>();
        if split_vec[0] == "jmp" {
            vec[i] = format!("nop {}", split_vec[1]);
        } else if split_vec[0] == "nop" {
            vec[i] = format!("jmp {}", split_vec[1]);
        }
        let mut accumulator =0;
        let mut curr_command =0;
        let mut visited = vec![false; vec.len()];
        while !visited[vec.len()-1] && visited[curr_command as usize] == false {
            visited[curr_command as usize] = true;
            let splitted=vec[curr_command as usize].split_whitespace();
            let split_vec = splitted.collect::<Vec<&str>>();

            if split_vec[0] == "jmp"{
                let argument: i32 = split_vec[1].parse().unwrap();
                curr_command += argument-1;
            }
            if split_vec[0] == "acc"{
                let argument: i32 = split_vec[1].parse().unwrap();
                accumulator += argument;
            }
            curr_command+=1;
        }

        if visited[vec.len() - 1] {
            return accumulator;
        }

        vec[i] = prev_value;
        i+=1;
    }
    return 0;
}

fn main() {

    let mut vec = Vec::new();
    if let Ok(lines) = read_lines("../input.txt") {
        for line in lines {
            if let Ok(var) = line {
                vec.push(var);
            }
        }
    }

    println!("Task1 solution: {}", task1(&vec));
    println!("Task1 solution: {}", task2(&vec));

}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
