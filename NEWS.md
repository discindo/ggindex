# ggindex 0.1.0

First release. The package was renamed from ggfocus, a name already used on
CRAN.

## Breaking changes

* `geom_focus()` draws only the numbered markers; add `geom_point()` for
  background points. The `background_*` parameters are removed.
* The markers use the standard `colour`, `fill`, `shape`, `size`, `stroke`
  and `alpha` aesthetics instead of `shape_colour`, `shape_fill` and
  `shape_focus`. `text_colour` is replaced by the `text.colour` parameter.
* ggplot2 (>= 4.0.0) is imported instead of attached; call `library(ggplot2)`.

## New features

* The `info` aesthetic builds a legend whose keys show the marker numbers,
  sorted by label (#1).
* `focus` is an optional aesthetic that selects the observations to number
  (#2).
* Without a `label` mapping, `info` entries are numbered 1, 2, 3, ... in data
  order.
* Markers grow to fit longer labels, and their defaults follow the theme.
* `geom_sf_focus()` numbers simple features from the sf package.
* New `scale_info_discrete()` and `draw_key_focus()`.
