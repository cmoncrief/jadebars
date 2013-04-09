program  = require 'commander'
jadebars = require './jadebars'

list = (val) ->
  val.split ','

module.exports.run =  ->

  program
    .version('0.3.0')
    .usage('[options] [path ...]')
    .option('-k, --known <helpers>', 'known helpers', list)
    .option('-K, --knownOnly ', 'known helpers only')
    .option('-m, --minify', 'minify output files')
    .option('-o, --output <path>', 'output path')
    .option('-s, --silent', 'suppress console output')
    .option('-w, --watch', 'watch files for changes')

    program.parse process.argv

    options =
      output    : program.output
      watch     : program.watch
      silent    : program.silent || false
      minify    : program.minify
      known     : program.known
      knownOnly : program.knownOnly

    console.log program.known

    console.log '' unless options.silent
    jadebars program.args, options
    console.log '' unless options.silent
