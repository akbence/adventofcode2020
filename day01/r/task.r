   read_input <- function() {
      fileName <- "../input.txt"
      conn <- file(fileName,open="r")
      lines <- readLines(conn, warn=FALSE)
      close(conn)
      numbers <- vector()
      for (i in 1:length(lines)){
         temp <- as.numeric(lines[i])
         numbers <- c(numbers, temp)
      }
      numbers
   }

   task1 <- function(numbers) {
      for (i in 1:length(numbers)) {
         for (j in i:length(numbers)) {
            if (sum(numbers[[i]], numbers[[j]]) == 2020) {
               cat("Task 2 solution:", numbers[[i]] * numbers[[j]] )   
            }
         }
      }
   }

   task2 <- function(numbers) {
      for (i in 1:length(numbers)) {
         for (j in i:length(numbers)) {
            for (k in j:length(numbers)) {
               if (sum(numbers[[i]], numbers[[j]], numbers[[k]]) == 2020) {
                  cat("Task 2 solution:", numbers[[i]] * numbers[[j]]* numbers[[k]] )   
               }
            }
         }
      }
   }
   

numbers <- read_input()
task1(numbers)
cat("\n")
task2(numbers)
cat("\n")
