import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Task {
    public static void main(String[] args) throws IOException {
        List<String> extractedLine = Files.readAllLines(Paths.get("../input.txt"));
    }
}