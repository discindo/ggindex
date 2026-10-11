sites <- data.frame(
  x = 1:4,
  y = 1:4,
  id = c(3, 1, 4, 2),
  name = c("c", "a", "d", "b"),
  keep = c(TRUE, TRUE, FALSE, TRUE)
)

test_that("every observation gets a marker when focus is not mapped", {
  p <- ggplot(sites, aes(x, y, label = id)) + geom_focus()
  expect_equal(nrow(layer_data(p)), 4)
})

test_that("focus keeps only TRUE observations and drops NA", {
  sites$keep[1] <- NA
  p <- ggplot(sites, aes(x, y, label = id, focus = keep)) + geom_focus()
  expect_equal(layer_data(p)$label, c(1, 2))
})

test_that("info legend lists focus points in label order", {
  p <- ggplot(sites, aes(x, y, label = id, focus = keep, info = name)) +
    geom_focus()
  expect_equal(layer_data(p)$info, c("c", "a", "b"))
  expect_equal(as.vector(get_guide_data(p, "info")$info), c("a", "b", "c"))
})

test_that("scale_info_discrete sets the legend title", {
  p <- ggplot(sites, aes(x, y, label = id, info = name)) +
    geom_focus() +
    scale_info_discrete("Index")
  expect_equal(get_labs(p)$info, "Index")
})

test_that("panels without focus points still draw", {
  p <- ggplot(sites, aes(x, y, label = id, focus = keep)) +
    geom_focus() +
    facet_wrap(vars(keep))
  expect_no_error(ggplotGrob(p))
})

test_that("legend key shows the label of its entry", {
  p <- ggplot(sites, aes(x, y, label = id, info = name)) + geom_focus()
  decor <- ggplot_build(p)@plot@guides$params[[1]]$decor[[1]]
  keys <- lapply(seq_len(nrow(decor$data)), function(i) {
    decor$draw_key(decor$data[i, ], decor$params, NULL)
  })
  expect_equal(
    vapply(keys, function(k) k$children[[2]]$label, ""),
    c("1", "2", "3", "4")
  )
})

test_that("info entries are numbered in data order when label is not mapped", {
  p <- ggplot(sites, aes(x, y, focus = keep, info = name)) + geom_focus()
  expect_equal(layer_data(p)$label, c(1, 2, 3))
  expect_equal(as.vector(get_guide_data(p, "info")$info), c("c", "a", "b"))
})

test_that("numbering runs across facets", {
  p <- ggplot(sites, aes(x, y, info = name)) +
    geom_focus() +
    facet_wrap(vars(x > 2))
  expect_equal(layer_data(p)$label, 1:4)
})

test_that("geom_focus needs label or info", {
  p <- ggplot(sites, aes(x, y)) + geom_focus()
  expect_error(ggplot_build(p), "`label` or `info`")
})
