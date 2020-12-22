import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class Task {
    public static void main(String[] args) throws IOException {
        long task1Count = 0;
        List<String> extractedLine = Files.readAllLines(Paths.get("../input.txt"));
        List<List<String>> ingredientList = new ArrayList<>();
        List<List<String>> allergenList = new ArrayList<>();
        Set<String> possibleAllergens = new HashSet<>();
        processInput(extractedLine, ingredientList, allergenList, possibleAllergens);

        Map<String, String> foodToAllergenMap = new HashMap<>();
        int lastSize = -1;
        while (allergenList.size() != foodToAllergenMap.size() && foodToAllergenMap.size() > lastSize) {
            lastSize = foodToAllergenMap.size();
            createFoodToAllergenMap(extractedLine, ingredientList, allergenList, possibleAllergens, foodToAllergenMap);
        }

        for (List<String> lineOfIngredient : ingredientList) {
            task1Count += lineOfIngredient.stream().filter(ingredient -> !foodToAllergenMap.containsKey(ingredient)).count();
        }

        StringBuilder sb = new StringBuilder();
        foodToAllergenMap.entrySet().stream().sorted(Map.Entry.comparingByValue()).forEach(entrySet -> {
            sb.append(entrySet.getKey()).append(",");
        });
        sb.setLength(sb.length() - 1);
        String task2String = sb.toString();

        System.out.println("Task1 solution: " + task1Count);
        System.out.println("Task1 solution: " + task2String);
    }

    private static void processInput(List<String> extractedLine, List<List<String>> ingredientList, List<List<String>> allergenList, Set<String> possibleAllergens) {
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
    }

    private static void createFoodToAllergenMap(List<String> extractedLine, List<List<String>> ingredientList, List<List<String>> allergenList, Set<String> possibleAllergens, Map<String, String> foodToAllergenMap) {
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
            if (foodsContainsAllergen.size() == 1) {
                deleteFromList(allergen, allergenList);
                deleteFromList(foodsContainsAllergen.stream().findFirst().get(), ingredientList);
                foodToAllergenMap.put(foodsContainsAllergen.stream().findFirst().get(), allergen);
                break;
            }
        }
    }

    private static void deleteFromList(String element, List<List<String>> elementList) {
        elementList.forEach(
                e -> e.remove(element)
        );
    }
}