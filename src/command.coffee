program  = require 'commander'
jadebars = require './jadebars'

module.exports.run =  ->

  program
    .version('0.1.0')
    .usage('[options] [path ...]')
    .option('-o, --output <path>', 'output path')
    .option('-w, --watch', 'watch files for changes')
    .option('-s, --silent', 'suppress console output')

    program.parse process.argv

    options =
      output  : program.output
      watch   : program.watch
      silent  : program.silent || false

    console.log '' unless options.silent
    jadebars program.args, options
    console.log '' unless options.silent
