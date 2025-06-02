# R Exercises

## Exercise 1: Inspect mtcars
1. Load the built-in `mtcars` dataset (`data(mtcars)`).
2. Print `head(mtcars)`, `str(mtcars)`, and `summary(mtcars)`.

## Exercise 2: Mean MPG by Cylinder
Use `aggregate()` to compute average `mpg` by `cyl`.

## Exercise 3: ggplot2 Scatterplot
1. Load `ggplot2` (`library(ggplot2)`).
2. Plot `mpg` vs. `hp`, colored by `factor(cyl)`:
   ```r
   ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl))) +
     geom_point(size = 3) +
     labs(
       title = "MPG vs. Horsepower by Cylinder Count",
       x = "Horsepower (hp)",
       y = "Miles per Gallon (mpg)",
       color = "Cylinders"
     ) +
     theme_minimal()
