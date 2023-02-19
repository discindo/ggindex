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
#' focus <- rep(c(TRUE, FALSE), each = 5)
#' info <- sprintf("Info for %s ", 1:10)
#' data <- data.frame(x, y, rank, focus, info)
#'
#' ggplot2::ggplot(data, ggplot2::aes(x, y, label = rank, focus = focus, info = info)) +
#'  geom_focus(text_colour = c('red', 'blue', 'red', 'blue', 'red'),
#'             shape_focus = 24,
#'             shape_colour = c('green', 'purple', 'green', 'purple', 'green'))  +
#'  ggplot2::scale_x_continuous(breaks = 1:10) +
#'  ggplot2::theme_minimal()
#'
#'
#'  ggplot2::ggplot(data, ggplot2::aes(x, y, label = rank, focus = focus, info = info)) +
#'   geom_focus(shape_focus = 24,
#'            aes(text_colour = focus, shape_colour = focus)) +
#'   ggplot2::scale_x_continuous(breaks = 1:10) +
#'   ggplot2::scale_color_viridis_d() +
#'   ggplot2::theme_minimal()
#'
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
           text_colour = NULL,
           shape_focus = NULL,
           shape_colour = NULL,
           ...) {
    ggplot2::layer(
      geom = GeomFocus,
      mapping = mapping,
      data = data,
      stat = stat,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(
        text_colour = text_colour,
        shape_focus = shape_focus,
        shape_colour = shape_colour,
        na.rm = na.rm,
        ...
      )
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

  draw_panel = function(data,
                        panel_params,
                        coord,
                        text_colour,
                        shape_focus,
                        shape_colour,
                        na.rm = TRUE) {
    coords <- coord$transform(data, panel_params)

    grob1 <- grid::pointsGrob(
      coords$x,
      coords$y,
      pch = coords$shape,
      gp = grid::gpar(col = coords$colour)
    )

    data_focus <- data[data$focus, ]
    coords_focus <- coord$transform(data_focus, panel_params)

    if (is.null(shape_focus)) {
      shape_focus = 23
    }

    if (is.null(shape_colour)) {
      shape_colour = "red"
    }

    grob2 <- grid::pointsGrob(
      coords_focus$x,
      coords_focus$y,
      pch = shape_focus,
      size = unit(20, units = "pt"),
      gp = grid::gpar(col = shape_colour)
    )

    if (is.null(text_colour)) {
      text_color = "green"
    }

    grob3 <- grid::textGrob(
      label = coords_focus$label,
      x = coords_focus$x,
      y = coords_focus$y,
      gp = grid::gpar(col = text_colour)
    )

    grid::gTree("focus_grob", children = grid::gList(grob1, grob2, grob3))
  }
)
