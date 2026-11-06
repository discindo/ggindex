## R CMD check results

0 errors | 0 warnings | 0 notes

This is a bug fix release.

Adds more documentation.

Updates the DESCRIPTION to reflect that it 
can be used on more than scatter plots.

devtools::check(remote = TRUE, manual = TRUE) shows 403 
on stackoverflow links, but the links are correct and
working. Maybe SO blocks automatic checks on its content.

## Test environments

R CMD check --as-cran on GitHub Actions:

* macOS (aarch64-apple-darwin23), R 4.6.2
* Windows (x86_64-w64-mingw32), R 4.6.2
* Ubuntu 24.04 (x86_64-pc-linux-gnu), R 4.6.2
* Ubuntu 24.04 (x86_64-pc-linux-gnu), R 4.5.3
