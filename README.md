clinkr
======

Composable Command Line Interfaces in R

[![Travis-CI Build Status](https://travis-ci.org/travisbyrum/clinkr.svg?branch=master)](https://travis-ci.org/travisbyrum/clinkr)
[![Coverage Status](https://img.shields.io/codecov/c/github/travisbyrum/clinkr/master.svg)](https://codecov.io/github/travisbyrum/clinkr?branch=master)

clinkr goal is to create usable argument parsing for R scripts using syntax that follows modern R idioms.

To install the latest development version from github, run the following:

``` r
devtools::install_github("travisbyrum/clinkr")
```

Examples
--------

The following provides an example of a running a command line R script using formatted arguments.
You first create a parser object and then specify options giving information as to their type, default, or whether or not it is specified as a flag.  In a hypothetical script call `test.R` you can do this through the following code:

``` r
args <- arg_parser() %>% 
  add_option(c('--verbose', '-v'), is_flag = TRUE, help = 'Prints verbose output.') %>%
  add_option('--multiply', type = 'numeric', help = 'Multiply by given number.') %>%
  parse_args(args = c('--verbose', '--multiply', '3'))
```
As you can see this follows modern R idioms and allows piping to more easily add options and arguments to the parser object.  Then after running the program in command line


``` bash
Rscript test.R --verbose --multiply 3
```

the following is returned:

``` r
args
#> $multiply
#> [1] 3
#>
#> $verbose
#> [1] TRUE
```

# Inspiration
- [Click](http://click.pocoo.org/5/) Python package for building command line interfaces.
- [docopt](http://docopt.org/) Follow docopt conventions for man pages.
- [argparse](https://docs.python.org/3/library/argparse.html) Another python module for command line tools.

# Todo
- Ability to add options and arguments with inherent type checking
- Generate docstrings
- Define entry points
- `set_argument` and `set_option` should probably be converted from S3 to R6
- `set_argument` and `set_option` type argument should include integer?
- Handle infinite argument lists
- Handle type mismatch between default and type when is_flag = `TRUE`
- Handle help option in list
- Parser test failing
- Build queue for positional arguments
