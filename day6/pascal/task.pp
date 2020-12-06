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
    writeln('Line: ',line);
  end;
end;

//main
begin
  read_input();
end.