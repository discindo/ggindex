# ggindex 0.1.1

## Bug fixes

* geom_sf_focus() numbers info entries alphabetically  ([#22](https://github.com/discindo/ggindex/issues/22)) ([442ede7](https://github.com/discindo/ggindex/commit/442ede79b69a1b730777273282c67ecbb72bbd1f))


## Documentation

* add articles beyond scatter plots ([#24](https://github.com/discindo/ggindex/issues/24)) ([7ee74ed](https://github.com/discindo/ggindex/commit/7ee74ed7ae64fa22eef73dded9a6390e5a60b8c6))

# ggindex 0.1.0

* Initial release.
* `geom_focus()` marks points with numbered markers, and the `info`
  aesthetic adds a legend that explains each number. The optional `focus`
  aesthetic selects which observations to number; without `label`, `info`
  entries are numbered in data order.
* `geom_sf_focus()` numbers simple features from the sf package.
* Markers take the standard ggplot2 aesthetics and scales, follow the theme,
  and grow to fit longer labels.
* `scale_info_discrete()` and `draw_key_focus()` build the legend.
