test_that("geom_sf_focus numbers simple features", {
  skip_if_not_installed("sf")
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  nc <- sf::st_transform(nc, 32119)
  nc_large <- nc[nc$AREA > 0.2, ]

  p <- ggplot(nc) +
    geom_sf(fill = "grey90", colour = "white") +
    geom_sf_focus(aes(info = NAME), data = nc_large)

  expect_equal(layer_data(p, 2)$label, seq_len(nrow(nc_large)))
  vdiffr::expect_doppelganger("sf map", p)
})
