#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  devtools::load_all('~/clinkr')
  library(dplyr)
})

args <- arg_parser() %>%
  add_option(c('--verbose', '-v'), is_flag = TRUE, help = 'Prints verbose output.') %>%
  add_option('--count', type = 'numeric', default = 2, help = 'Prints verbose output.') %>%
  add_option('--multiply', type = 'numeric', help = 'Multiply by given number,') %>%
  parse_args()

print(args)
