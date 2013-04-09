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
    @known = {}

    @options.watch ?= false
    @options.silent ?= true
    @options.minify ?= false
    @options.join = true if @options.output and path.extname(@options.output)

    unless Array.isArray(@options.known) then @options.known = [@options.known]
    @known[item] = true for item in @options.known if @options.known

    @initColors()
    @initPaths()

    @compileAll()

  compileAll: ->

    for inputPath in @inputPaths
      files = glob.sync inputPath
      @addSource file, inputPath for file in files

    @compile source for source in @sources
    @write()

    if @options.watch
      @watch i for i in @inputPaths

  addSource: (file, inputPath = file) ->

    source = file: file, input: path.resolve(file), inputPath: inputPath, writeTime: 0
    @sources.push source
    source

  initPaths: ->

    unless Array.isArray(@inputPaths) then @inputPaths = [@inputPaths]
    for inputPath, i in @inputPaths
      unless path.extname(inputPath)
        @inputPaths[i] = "#{inputPath}/**/*.jade"

  compile: (source) ->

    input = fs.readFileSync source.file, 'utf8'
    opts = knownHelpers: @known, knownHelpersOnly: @options.knownOnly

    try
      html = jade.compile(input, {})()
      source.compiled = handlebars.precompile html, opts
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
      if source.inputPath[0] is path.sep
        baseInputDir = source.inputPath.replace '**/*.jade', ''
        baseInputDir = baseInputDir.replace new RegExp("#{path.basename(baseInputDir)}/$"), ''
        baseInputDir = path.normalize baseInputDir
        baseOutputDir = dir.replace baseInputDir, ''
        baseFragment = baseOutputDir.substr 0, baseOutputDir.indexOf(path.sep)
        baseDir = baseOutputDir.replace new RegExp("^#{baseFragment}"), ''
        dir = if baseFragment then path.join(@options.output, baseDir) else @options.output
      else if source.inputPath.indexOf path.sep
        baseDir = source.inputPath.substr 0, source.inputPath.indexOf(path.sep)
        dir = dir.replace new RegExp("^#{baseDir}"), @options.output
      else
        dir = @options.output

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
