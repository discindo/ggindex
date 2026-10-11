# ggindex 0.1.1

## Documentation

* add plain-text hex logo to README ([#10](https://github.com/discindo/ggindex/issues/10)) ([5d369e0](https://github.com/discindo/ggindex/commit/5d369e0bf36b78b49452bb45a6201f4ca252fded))

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
