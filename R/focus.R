#' Numbered focus points
#'
#' @description
#' Draws a marker carrying a text `label` (typically a rank or index) at each
#' observation. Without a `label` mapping, the `info` entries are numbered 1,
#' 2, 3, ... in the order they appear in the data. Map `focus` to a logical variable to draw markers only for the
#' observations where it is `TRUE`; add [ggplot2::geom_point()] to show the
#' other observations as background. When `info` is mapped, a legend is added
#' that pairs each numbered marker with its description.
#'
#' Map `label`, `focus` and `info` in `geom_focus()` rather than in
#' [ggplot2::ggplot()] when the plot has other layers. Layers inherit the
#' plot mapping, so their observations would also appear in the `info`
#' legend.
#'
#' The markers use the standard `colour`, `fill`, `shape`, `size`, `stroke`
#' and `alpha` aesthetics, so the usual ggplot2 scales apply to them. Their
#' defaults come from the theme: a `paper` filled circle with an `ink` border
#' and label. A marker grows beyond `size` when its label needs more room.
#'
#' Markers are drawn at the data positions and don't avoid each other. To
#' separate markers that overlap, map `nudge_x` or `nudge_y` and set
#' `position = "nudge"`.
#'
#' @section Aesthetics:
#' Required: `x`, `y`, and `label` or `info`.
#' Optional: `label` (numbers the `info` entries when not mapped), `focus`
#' (logical; when not mapped, every observation gets a marker), `info`, `colour`, `fill`, `shape`, `size`, `stroke`, `alpha`,
#' `family`, `fontface`.
#'
#' `geom_sf_focus()` places the markers on simple features from the 'sf'
#' package, at the coordinates computed by [ggplot2::stat_sf_coordinates()]:
#' the point itself, or a point on the surface of a line or polygon.
#'
#' @inheritParams ggplot2::geom_point
#' @inheritParams ggplot2::stat_sf_coordinates
#' @param text.colour,text.color Colour of the labels. `NULL` uses the
#'   `colour` aesthetic, the marker border colour.
#' @param text.size Size of the labels in mm.
#'
#' @examples
#' library(ggplot2)
#'
#' data <- data.frame(
#'   x = 1:10,
#'   y = c(3, 5, 2, 8, 6, 4, 7, 1, 9, 5),
#'   rank = 1:10,
#'   focus = rep(c(TRUE, FALSE), each = 5),
#'   info = sprintf("Info for %s", 1:10)
#' )
#'
#' ggplot(data, aes(x, y, label = rank, info = info)) +
#'   geom_focus() +
#'   theme_minimal()
#'
#' # Number a subset and keep the rest as background points. Map label,
#' # focus and info in geom_focus(): other layers would inherit them from
#' # ggplot(), and their data would train the info legend.
#' ggplot(data, aes(x, y)) +
#'   geom_point(colour = "grey60") +
#'   geom_focus(aes(label = rank, focus = focus, info = info)) +
#'   theme_minimal()
#'
#' @examplesIf requireNamespace("sf", quietly = TRUE)
#' # Number counties on a map
#' nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' nc <- sf::st_transform(nc, 32119)
#' nc_large <- nc[nc$AREA > 0.2, ]
#'
#' ggplot(nc) +
#'   geom_sf(fill = "grey90", colour = "white") +
#'   geom_sf_focus(aes(info = NAME), data = nc_large) +
#'   theme_void()
#'
#' @return A ggplot2 layer.
#' @export
geom_focus <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  text.colour = NULL,
  text.color = NULL,
  text.size = 3.87,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  ggplot2::layer(
    geom = GeomFocus,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      text.colour = if (is.null(text.color)) text.colour else text.color,
      text.size = text.size,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_focus
#' @export
geom_sf_focus <- function(
  mapping = ggplot2::aes(),
  data = NULL,
  stat = "sf_coordinates",
  position = "identity",
  ...,
  text.colour = NULL,
  text.color = NULL,
  text.size = 3.87,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  fun.geometry = NULL
) {
  ggplot2::layer_sf(
    geom = GeomFocus,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      text.colour = if (is.null(text.color)) text.colour else text.color,
      text.size = text.size,
      na.rm = na.rm,
      fun.geometry = fun.geometry,
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
  ggplot2::Geom,
  required_aes = c("x", "y"),
  optional_aes = c("label", "focus"),
  non_missing_aes = c("colour", "fill", "shape", "size"),
  default_aes = ggplot2::aes(
    colour = ggplot2::from_theme(ink),
    fill = ggplot2::from_theme(paper),
    shape = 21,
    size = 6,
    stroke = ggplot2::from_theme(borderwidth),
    alpha = NA,
    family = ggplot2::from_theme(family),
    fontface = 1,
    info = NA
  ),

  setup_params = function(data, params) {
    # Lets the legend key show the label of each info entry
    if (!is.null(data$info)) {
      data <- focus_prepare(data)
      info_labels <- as.character(data$label)
      names(info_labels) <- as.character(data$info)
      params$info_labels <- info_labels
    }
    params
  },

  setup_data = function(data, params) {
    data <- focus_prepare(data)
    data$focus <- NULL
    if (!is.null(data$info)) {
      # Legend entries follow the label order
      info <- as.character(data$info)
      data$info <- factor(info, levels = unique(info[order(data$label)]))
    }
    data
  },

  draw_panel = function(
    data,
    panel_params,
    coord,
    text.colour = NULL,
    text.size = 3.87,
    na.rm = FALSE
  ) {
    coords <- coord$transform(data, panel_params)
    # Markers are sized to their labels in makeContent(), when the font
    # metrics of the output device are known
    grid::gTree(
      name = "geom_focus",
      data = coords,
      text.colour = text.colour,
      text.size = text.size,
      cl = "focus_grob"
    )
  },

  draw_key = function(data, params, size) {
    draw_key_focus(data, params, size)
  }
)

#' Legend key for numbered markers
#'
#' Draws the marker of [geom_focus()] with the label of its legend entry
#' inside. The label is looked up from the `info` value of the key in
#' `params$info_labels`; without a match only the marker is drawn.
#'
#' @param data A single row data frame with the scaled aesthetics.
#' @param params A list of layer parameters.
#' @param size Width and height of the key in mm (unused).
#' @return A grob.
#' @export
draw_key_focus <- function(data, params, size) {
  label <- params$info_labels[as.character(data$info)]
  if (length(label) == 0 || is.na(label)) {
    return(grid::pointsGrob(
      0.5,
      0.5,
      pch = data$shape,
      gp = focus_marker_gpar(data)
    ))
  }
  data$label <- label
  data$size <- focus_fit_size(data, params$text.size)
  grob <- grid::grobTree(
    grid::pointsGrob(0.5, 0.5, pch = data$shape, gp = focus_marker_gpar(data)),
    grid::textGrob(
      label,
      gp = focus_text_gpar(data, params$text.colour, params$text.size)
    )
  )
  attr(grob, "width") <- attr(grob, "height") <- data$size / 10
  grob
}

#' @exportS3Method grid::makeContent
makeContent.focus_grob <- function(x) {
  data <- x$data
  data$size <- focus_fit_size(data, x$text.size)
  markers <- grid::pointsGrob(
    data$x,
    data$y,
    pch = data$shape,
    gp = focus_marker_gpar(data)
  )
  labels <- grid::textGrob(
    data$label,
    data$x,
    data$y,
    default.units = "native",
    gp = focus_text_gpar(data, x$text.colour, x$text.size)
  )
  grid::setChildren(x, grid::gList(markers, labels))
}

# Marker size that fits the label: at least `size`, or large enough for the
# label's bounding box to fit inside the marker. Filled point shapes are
# 0.75 * size wide.
focus_fit_size <- function(data, text.size) {
  fontsize <- text.size * ggplot2::.pt
  width <- vapply(
    seq_len(nrow(data)),
    function(i) {
      text <- grid::textGrob(
        data$label[i],
        gp = grid::gpar(
          fontsize = fontsize,
          fontfamily = data$family[i],
          fontface = data$fontface[i]
        )
      )
      grid::convertWidth(grid::grobWidth(text), "mm", valueOnly = TRUE)
    },
    numeric(1)
  )
  height <- 0.7 * text.size
  diameter <- sqrt(width^2 + height^2) + 0.5
  pmax(data$size, diameter / 0.75)
}

# Keeps the focus observations and numbers the info entries when label is
# not mapped
focus_prepare <- function(data) {
  data <- focus_subset(data)
  if (is.null(data$label)) {
    if (is.null(data$info)) {
      stop(
        "`geom_focus()` requires the `label` or `info` aesthetic.",
        call. = FALSE
      )
    }
    info <- as.character(data$info)
    data$label <- match(info, unique(info))
  }
  data
}

focus_subset <- function(data) {
  if (is.null(data$focus)) {
    return(data)
  }
  data[as.logical(data$focus) %in% TRUE, , drop = FALSE]
}

focus_text_gpar <- function(data, colour, size) {
  grid::gpar(
    col = ggplot2::alpha(
      if (is.null(colour)) data$colour else colour,
      data$alpha
    ),
    fontsize = size * ggplot2::.pt,
    fontfamily = data$family,
    fontface = data$fontface
  )
}

focus_marker_gpar <- function(data) {
  stroke <- data$stroke * ggplot2::.stroke / 2
  grid::gpar(
    col = ggplot2::alpha(data$colour, data$alpha),
    fill = ggplot2::fill_alpha(data$fill, data$alpha),
    fontsize = data$size * ggplot2::.pt + stroke,
    lwd = stroke
  )
}

#' Scale for the `info` aesthetic of [geom_focus()]
#'
#' Builds the legend that lists the description of each numbered marker. It
#' is added automatically when `info` is mapped; call it directly to change the
#' legend title or other legend settings.
#'
#' @inheritParams ggplot2::discrete_scale
#' @param ... Other arguments passed on to [ggplot2::discrete_scale()].
#' @export
scale_info_discrete <- function(
  name = ggplot2::waiver(),
  ...,
  guide = "legend"
) {
  ggplot2::discrete_scale(
    "info",
    name = name,
    palette = scales::pal_identity(),
    ...,
    guide = guide,
    super = ggplot2::ScaleDiscreteIdentity
  )
}
