# solution_example.R
# Placeholder R solution

# Exercise 1: Inspect mtcars
data(mtcars)
print(head(mtcars))
print(str(mtcars))
print(summary(mtcars))

# Exercise 2: Mean MPG by Cylinder
mean_mpg_by_cyl <- aggregate(mpg ~ cyl, data = mtcars, FUN = mean)
print(mean_mpg_by_cyl)

# Exercise 3: ggplot2 Scatterplot
if (!require(ggplot2)) {
  install.packages("ggplot2", repos = "http://cran.us.r-project.org")
}
library(ggplot2)

ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "MPG vs. Horsepower by Cylinder Count",
    x = "Horsepower (hp)",
    y = "Miles per Gallon (mpg)",
    color = "Cylinders"
  ) +
  theme_minimal()
