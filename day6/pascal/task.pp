program Task;

var
  inputFile: TextFile;
  lines: array of string;


procedure read_input();
var
  line : String;
  list_length : integer;
begin
  assign(inputFile, '../input.txt');
  reset(inputFile);
  lines := [];
  while not eof(inputFile) do
  begin
    readln(inputFile,line);
    list_length := length(lines);
    SetLength(lines, list_length + 1);
    lines[list_length] := line;
  end;
end;

function add_answers_in_group_to_current(group_lines: array of string; answers : integer): integer;
var
  group_answers : integer;
  different_chars: set of char;
  character : char;
  line : string;
begin
  group_answers := 0;
  different_chars := [];
  for line in group_lines do
  begin
    for character in line do
    begin
      different_chars := different_chars + [character];
    end;
  end;
  for character in different_chars do
  begin
    group_answers := group_answers + 1;
  end;
  add_answers_in_group_to_current := group_answers + answers;
end;

function add_answers_in_group_to_current2(group_lines: array of string; answers : integer): integer;
var
  group_answers : integer;
  cummulative_chars: set of char;
  line_set :set of char;
  character : char;
  line : string;
begin
  group_answers := 0;
  cummulative_chars :=  ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
  line_set:= [];
  for line in group_lines do
  begin
    for character in line do
    begin
      line_set := line_set + [character];
    end;
    cummulative_chars := cummulative_chars * line_set;
    line_set := [];
  end;
  for character in cummulative_chars do
  begin
    group_answers := group_answers + 1;
  end;
  add_answers_in_group_to_current2 := group_answers + answers;
end;


procedure task1();
var 
  group_lines : array of string;
  line : string;
  list_length : integer;
  answers : integer;
begin
  answers := 0;
  group_lines := [];
  for line in lines do
  begin
    if  not (length(line) = 0) then
    begin
      list_length := length(group_lines);
      SetLength(group_lines, list_length + 1);
      group_lines[list_length] := line;
    end
    else
    begin
      answers := add_answers_in_group_to_current(group_lines, answers);
      group_lines := [];
    end;
  end;
  writeln('Task1 solution: ', answers);
end;

procedure task2();
var 
  group_lines : array of string;
  line : string;
  list_length : integer;
  answers : integer;
begin
  answers := 0;
  group_lines := [];
  for line in lines do
  begin
    if  not (length(line) = 0) then
    begin
      list_length := length(group_lines);
      SetLength(group_lines, list_length + 1);
      group_lines[list_length] := line;
    end
    else
    begin
      answers := add_answers_in_group_to_current2(group_lines, answers);
      group_lines := [];
    end;
  end;
  writeln('Task2 solution: ', answers);
end;


//main
begin
  read_input();
  task1();
  task2();
end.