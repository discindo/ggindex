#' geom_focus
#'
#' @description Work in progress!!
#' A three-layer geom for plotting background scatter with focus
#' data points highlighted by a different symbol and numeric index. The focus
#' data points are set by a variable `focus` (TRUE/FALSE), the numeric rank by
#' a variable `rank`, and the legend is created with values from variable `info`.
#'
#' @examples
#'
#' x <- 1:10
#' y <- rep(2, 10)
#' rank <- 1:10
#' focus <- rep(c(T, F), each = 5)
#' info <- sprintf("Info for %s ", 1:10)
#' data <- data.frame(x, y, rank, focus, info)
#'
#' ggplot2::ggplot(data, ggplot2::aes(x, y, label = rank, focus = focus, info = info)) +
#'   geom_focus() +
#'   ggplot2::scale_x_continuous(breaks = 1:10) +
#'   ggplot2::theme_minimal()
#'
#' @export
geom_focus <-
  function(mapping = NULL,
           data = NULL,
           stat = "identity",
           position = "identity",
           na.rm = FALSE,
           show.legend = NA,
           inherit.aes = TRUE,
           ...) {
    ggplot2::layer(
      geom = GeomFocus,
      mapping = mapping,
      data = data,
      stat = stat,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }

#' @rdname geom_focus
#' @format NULL
#' @usage NULL
#' @export
GeomFocus <- ggplot2::ggproto(
  "GeomFocus",
  Geom,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(shape = 19, colour = "black"),
  draw_key = ggplot2::draw_key_point,

  draw_panel = function(data, panel_params, coord) {
    coords <- coord$transform(data, panel_params)

    grob1 <- grid::pointsGrob(
      coords$x,
      coords$y,
      pch = coords$shape,
      gp = grid::gpar(col = coords$colour)
    )

    data_focus <- data[data$focus,]
    coords_focus <- coord$transform(data_focus, panel_params)

    grob2 <- grid::pointsGrob(
      coords_focus$x,
      coords_focus$y,
      pch = 23,
      size = unit(20, units = "pt"),
      gp = grid::gpar(col = "red")
    )

    grob3 <- grid::textGrob(
      label = coords_focus$label,
      x = coords_focus$x,
      y = coords_focus$y,
      gp = grid::gpar(col = "blue")
    )

    grid::gTree("focus_grob", children = grid::gList(grob1, grob2, grob3))
  }
)

