# clinkr

Composable Command Line Interfaces in R

[![Travis-CI Build Status](https://travis-ci.org/travisbyrum/clinkr.svg?branch=master)](https://travis-ci.org/travisbyrum/clinkr)

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
- Fix is_truthy
- Parser test failing
- Build queue for positional arguments
