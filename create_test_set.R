set.seed(123)

dir.create("tests", showWarnings = FALSE)

wr <- function(data, name){
  write.table(data, paste0("tests/", name, ".csv"), row.names = FALSE, sep = ";")
}

# Base data

#all with semicolons to facilitate testing
wr(iris, "iris")

#with no character columns
wr(iris[,c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")],
            "iris_no_character")

#with no numeric cols
wr(iris[,"Species"], "iris_no_numeric")

#with multiple character cols
mcc <- iris
mcc[,"colour"] <- sample(rep_len(c("red", "green", "blue"), nrow(mcc)))
wr(mcc, "iris_2_character")
