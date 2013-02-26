fs         = require 'fs'
path       = require 'path'
jade       = require 'jade'
handlebars = require 'handlebars'
glob       = require 'glob'
mkdirp     = require 'mkdirp'
beholder   = require 'beholder'
uglify     = require 'uglify-js'
xcolor     = require 'xcolor'


class Jadebars

  constructor: (@inputPaths, @options = {}) ->

    @sources = []
    
    @options.watch ?= false
    @options.silent ?= true
    @options.minify ?= false
    @options.join = true if @options.output and path.extname(@options.output)

    @initColors()
    @initPaths()

    @compileAll()

  compileAll: ->

    for inputPath in @inputPaths
      files = glob.sync inputPath
      @addSource file for file in files

    @compile source for source in @sources
    @write()

    if @options.watch
      @watch i for i in @inputPaths

  addSource: (file) ->

    source = file: file, input: path.resolve(file), writeTime: 0
    @sources.push source
    source

  initPaths: ->

    unless Array.isArray(@inputPaths) then @inputPaths = [@inputPaths]
    for inputPath, i in @inputPaths
      unless path.extname(inputPath)
        @inputPaths[i] = "#{inputPath}/**/*.jade"

  compile: (source) ->

    input = fs.readFileSync source.file, 'utf8'

    try
      html = jade.compile(input, {})()
      source.compiled = handlebars.precompile html, {}
      source.compileTime = new Date().getTime()
    catch error
      unless @options.silent
        xcolor.log "  #{(new Date).toLocaleTimeString()} - {{bold}}{{.error}}Error at{{/bold}} #{source.file}: #{error}"
      return

  write: ->

    if @options.join
      @writeOutput @joinSources(), true
    else
      @writeOutput i for i in @sources when i.compileTime > i.writeTime

  writeOutput: (source, joined) ->
    
    @initOutput source unless joined
    mkdirp.sync path.dirname(source.outputPath)
    fs.writeFileSync source.outputPath, source.output, 'utf8'
    source.writeTime = new Date().getTime()

    unless @options.silent
      xcolor.log "  #{(new Date).toLocaleTimeString()} - {{.boldJade}}Compiled{{/color}} {{.jade}}#{source.outputPath}"

  initOutput: (source) ->
  
    @setOutputPath source
    @wrapSource source

  setOutputPath: (source) ->

    return source if source.outputPath

    fileName = path.basename(source.file, '.jade') + '.js'
    dir = path.dirname source.file

    if @options.output
      dir = dir.replace source.input, @options.output

    source.outputPath = path.join dir, fileName

  watch: (inputPath) ->
    
    watcher = beholder inputPath

    watcher.on 'change', (file) =>
      source = i for i in @sources when i.file is file
      @compile source
      @write()

    watcher.on 'new', (file) =>
      newSource = @addSource file
      @compile newSource
      @write()

    watcher.on 'remove', (file) =>
      @sources = (i for i in @sources when i.file isnt file)
      @write() if @options.join

  joinSources: ->

    output = """
        (function() {
          var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
        """

    for i in @sources
      output += "\ntemplates['#{path.basename(i.file, '.jade')}'] = template(#{i.compiled});"

    output += "\n})();\n"
    
    output = @minify output if @options.minify
    {outputPath: @options.output, output: output}

  minify: (input) ->

    result = uglify.minify input, {fromString: true}
    result.code

  wrapSource: (source) ->

    source.output = """
         (function() {
           var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
         templates['#{path.basename(source.file, '.jade')}'] = template(#{source.compiled});
         })();
         """

    source.output = @minify source.output if @options.minify

  initColors: ->

    xcolor.addStyle jade     : '#00A86B'
    xcolor.addStyle boldJade : ['bold', '#00A86B']
    xcolor.addStyle error    : 'crimson'

module.exports = (inputPaths, options) ->
  new Jadebars(inputPaths, options)
