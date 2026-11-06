test_that("geom_sf_focus numbers simple features", {
  skip_if_not_installed("sf")
  skip_if_not_installed("vdiffr")
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  nc <- sf::st_transform(nc, 32119)
  nc_large <- nc[nc$AREA > 0.2, ]

  p <- ggplot(nc) +
    geom_sf(fill = "grey90", colour = "white") +
    geom_sf_focus(aes(info = NAME), data = nc_large)

  expect_equal(layer_data(p, 2)$label, seq_len(nrow(nc_large)))
  vdiffr::expect_doppelganger("sf map", p)
})

test_that("geom_sf_focus numbers info entries in data order", {
  skip_if_not_installed("sf")
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  nc <- sf::st_transform(nc, 32119)
  # Data order is not alphabetical: Wake comes first
  nc_large <- nc[nc$AREA > 0.2, ]

  p <- ggplot(nc_large) +
    geom_sf_focus(aes(info = NAME, focus = AREA > 0.21))

  data <- layer_data(p)
  focus <- nc_large$NAME[nc_large$AREA > 0.21]
  expect_equal(
    data$label[match(focus, data$info)],
    seq_along(focus)
  )
})
