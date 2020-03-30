
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wranglEHR <a href='https://inform-health-informatics.github.io/wranglEHR/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Lifecycle
Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/)
<!-- badges: end -->

## Overview

wranglEHR is a data wrangling tool for EMAP. It is designed to run
against OMOP CDM 5.3.1. Please see the `R` vignettes for further details
on how to use the package to perform the most common tasks:

  - `extract()` produces a rectangular table in a “long” format that is
    suitable for most statistial packages.
  - `clean()` cleans the above table in accordance with pre-defined
    standards (pending)

## Installation

``` r
# install directly from github with
remotes::install_github("inform-health-informatics/wranglEHR")
```

## Usage

More documentation to follow

``` r
library(wranglEHR)

ctn <- ctn <- DBI::dbConnect(
  RPostgres::Postgres(),
  host = "****", # Host target for the UDS
  port = 5432,
  user = "****",
  password = rstudioapi::askForPassword(),
  dbname = "uds")

# Extract variables.
# Rename on the fly.
# Dynamically set time cadance.
ltb <- extract(
  connection = ctn,
  target_schema = "ops_dev",
  visit_occurrence_ids = 600000:600005,
  concept_names = c(3013502, 44809212),
  rename = c("spo2", "spo2_target"),
  coalesce_rows = dplyr::first,
  chunk_size = 5000,
  cadance = 1
)

head(ltb)

# Don't forget to switch of the lights after you leave
DBI::dbDisconnect(ctn)
```

## Getting help

If you find a bug, please file a minimal reproducible example on
[github](https://github.com/inform-health-informatics/wranglEHR/issues).
