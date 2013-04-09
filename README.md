# Jadebars

Jadebars is a simple tool for compiling Jade files into precompiled Handlebars templates. Jadebars can be used from the command line or via its public API.

### Features

* Minification
* Concatenation of multiple files
* Supports known helper optimizations
* Robust file watching
* Cross-platform

## Installation

Install globally via npm:

    $ npm install -g jadebars

## Usage
    Usage: jadebars [options] [path ...]

    Options:

    -h, --help             output usage information
    -V, --version          output the version number
    -k, --known <helpers>  known helpers
    -K, --knownOnly        known helpers only
    -m, --minify           minify output files
    -o, --output <path>    output path
    -s, --silent           suppress console output
    -w, --watch            watch files for changes

#### Examples

Compile a single file:
    
    $ jadebars test.jade

Compile an entire directory tree to an an output directory:
    
    $ jadebars -o output templates

Compile a directory tree into a single file:
    
    $ jadebars -o templates.js templates

Compile with minification:

    $ jadebars -m test.jade

Compile and watch for changes:

    $ jadebars -w templates

All together now (concatenate, minify, and watch):

    $ jadebars -mwo templates.js templates

## API

#### jadebars(inputPaths, [options])

Compiles all .jade files found in `inputPaths`, which can be a single string or an array of strings. 

##### Options:

* `known` - Array of known helpers to pass to the Handlebars compiler. 
* `knownOnly` - If all helpers are known in advance this may be used to optimize all block helper references. Defaults to false.
* `minify` - Compress output files. Defaults to false.
* `output` - The path to the output file. If the path has a file extension, all files will be joined at that location. Otherwise, the path is assumed to be a directory.
* `silent` - Suppress all console output. Defaults to true.
* `watch` - Watch all files and directories for changes and recompile automatically. Defaults to false.

##### Example:

    var jadebars = require('jadebars')

    jadebars('templates', {output: 'javascripts/templates.js'})

## Running the tests

To run the test suite, invoke the following commands in the repository:

    $ npm install
    $ npm test

## License

(The MIT License)

Copyright (c) 2013 Charles Moncrief <<cmoncrief@gmail.com>>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.