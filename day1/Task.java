import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Task {
    public static void main(String[] args) throws IOException {
        List<String> extractedLine = Files.readAllLines(Path.of(Paths.get("").toAbsolutePath().toString() + "/day1/input.txt"));
        Integer result = findEntriesAndMultiply(extractedLine);
        System.out.println(result);
    }

    private static Integer findEntriesAndMultiply(List<String> extractedLine) {
        List<Integer> numbers = extractedLine.stream().mapToInt(Integer::parseInt).boxed().collect(Collectors.toList());
        for (int i = 0; i < numbers.size(); i++) {
            for (int j = i + 1; j < numbers.size(); j++) {
                if (numbers.get(i) + numbers.get(j) == 2020) {
                    System.out.println(numbers.get(i) + ", and " + numbers.get(j));
                    return numbers.get(i) * numbers.get(j);
                }
            }
        }
        throw new RuntimeException("no result found");
    }
}