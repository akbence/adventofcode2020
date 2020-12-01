import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Task {
    public static void main(String[] args) throws IOException {
        List<String> extractedLine = Files.readAllLines(Paths.get("./day1/input.txt"));
        Integer result = findEntriesAndMultiply(extractedLine);
        System.out.println("Task 1 solution: " + result);
        Integer task2Result = findThreeEntriesAndMultiply(extractedLine);
        System.out.println("Task 2 solution: " + task2Result);
    }

    private static Integer findEntriesAndMultiply(List<String> extractedLine) {
        List<Integer> numbers = extractedLine.stream().mapToInt(Integer::parseInt).boxed().collect(Collectors.toList());
        for (int i = 0; i < numbers.size(); i++) {
            for (int j = i + 1; j < numbers.size(); j++) {
                for (int k = i + 1; k < numbers.size(); k++) {
                    if (numbers.get(i) + numbers.get(j) + numbers.get(k) == 2020) {
                        System.out.println(numbers.get(i) + ", and " + numbers.get(j) + ", and " + numbers.get(k));
                        return numbers.get(i) * numbers.get(j) * numbers.get(k);
                    }
                }
            }
        }
        throw new RuntimeException("no result found");
    }

    private static Integer findThreeEntriesAndMultiply(List<String> extractedLine) {
        List<Integer> numbers = extractedLine.stream().mapToInt(Integer::parseInt).boxed().collect(Collectors.toList());
        for (int i = 0; i < numbers.size(); i++) {
            for (int j = i + 1; j < numbers.size(); j++) {
                for (int k = j + 1; k < numbers.size(); k++) {
                    if (numbers.get(i) + numbers.get(j) + numbers.get(k) == 2020) {
                        System.out.println(numbers.get(i) + ", and " + numbers.get(j) + ", and" + numbers.get(k));
                        return numbers.get(i) * numbers.get(j) * numbers.get(k);
                    }
                }
            }
        }
        throw new RuntimeException("no result found");
    }
}