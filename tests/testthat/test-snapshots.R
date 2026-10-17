skip_if_not_installed("vdiffr")

cars <- mtcars
cars$model <- rownames(cars)
cars$rank <- rank(-cars$mpg, ties.method = "first")

test_that("geom_focus draws numbered markers and an info legend", {
  p <- ggplot(cars, aes(wt, mpg)) +
    geom_point(colour = "grey60") +
    geom_focus(aes(label = rank, focus = rank <= 5, info = model))
  vdiffr::expect_doppelganger("info legend", p)
})

test_that("geom_focus markers take scales and text styling", {
  p <- ggplot(cars, aes(wt, mpg)) +
    geom_focus(
      aes(label = rank, focus = rank <= 5, fill = factor(gear)),
      shape = 22,
      text.colour = "white",
      fontface = "bold"
    )
  vdiffr::expect_doppelganger("fill scale and text styling", p)
})

test_that("geom_focus follows the theme", {
  p <- ggplot(cars, aes(wt, mpg, label = rank, focus = rank <= 3)) +
    geom_focus() +
    theme_dark()
  vdiffr::expect_doppelganger("dark theme", p)
})

test_that("markers grow to fit long labels", {
  d <- data.frame(
    x = 1:4,
    y = 1:4,
    id = c(1, 11, 117, 4),
    name = c("One", "Eleven", "Hundred seventeen", "Four")
  )
  p <- ggplot(d, aes(x, y, label = id, info = name)) + geom_focus()
  vdiffr::expect_doppelganger("label fitted markers", p)
})
