program  = require 'commander'
jadebars = require './jadebars'

module.exports.run =  ->

  program
    .version('0.2.1')
    .usage('[options] [path ...]')
    .option('-m, --minify', 'minify output files')
    .option('-o, --output <path>', 'output path')
    .option('-s, --silent', 'suppress console output')
    .option('-w, --watch', 'watch files for changes')

    program.parse process.argv

    options =
      output  : program.output
      watch   : program.watch
      silent  : program.silent || false
      minify  : program.minify

    console.log '' unless options.silent
    jadebars program.args, options
    console.log '' unless options.silent
