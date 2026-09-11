# babysteps2git

A tiny example R package used to bootstrap and validate a Cloud Agent
development environment for R package development. It exists so the standard R
package workflow — documenting, testing, and `R CMD check` — can be exercised
end to end.

## Functions

- `add_numbers(x, y)` — return the sum of two numeric values.
- `greet(name)` — build a greeting string.

## Development

The Cloud Agent environment installs R and the package-development toolkit
(`devtools`, `roxygen2`, `testthat`, `rcmdcheck`, `knitr`, `rmarkdown`,
`usethis`). Common commands:

```r
# From an R session at the package root:
devtools::document()   # regenerate NAMESPACE and man/ from roxygen comments
devtools::test()       # run the testthat suite
devtools::check()      # run R CMD check
```

From the shell:

```sh
R -q -e 'devtools::test()'
R CMD build .
R CMD check babysteps2git_*.tar.gz --no-manual
```
