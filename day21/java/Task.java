import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class Task {
    public static void main(String[] args) throws IOException {
        List<String> extractedLine = Files.readAllLines(Paths.get("../input.txt"));
        List<List<String>> ingredientList = new ArrayList<>();
        List<List<String>> allergenList = new ArrayList<>();
        Set<String> possibleAllergens = new HashSet<>();
        extractedLine.forEach(line -> {
            String[] splitted = line.trim().split("\\(");
            List<String> allergens = new ArrayList<>();
            if (splitted.length == 2) {
                allergens = Arrays.stream(splitted[1].replace("contains ", "").replace(")", "")
                        .replace(",", "").split(" ")).map(String::trim).collect(Collectors.toList());
                possibleAllergens.addAll(allergens);
            }
            ingredientList.add(Arrays.stream(splitted[0].split(" ")).map(String::trim).collect(Collectors.toList()));
            allergenList.add(allergens);
        });

        for (String allergen : possibleAllergens) {
            Set<String> foodsContainsAllergen = new HashSet<>();
            for (int i = 0; i < extractedLine.size(); i++) {
                if (allergenList.get(i).contains(allergen)) {
                    if (foodsContainsAllergen.isEmpty()) {
                        foodsContainsAllergen.addAll(ingredientList.get(i));
                    } else {
                        foodsContainsAllergen.retainAll(ingredientList.get(i));
                    }
                }
            }
            System.out.println(allergen + " possibilities: " + foodsContainsAllergen);
        }
    }
}