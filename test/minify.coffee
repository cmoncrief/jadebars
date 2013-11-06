assert       = require 'assert'
fs           = require 'fs'
path         = require 'path'
jadebars     = require '../lib/jadebars'

fixturePath = path.join __dirname, 'fixtures'

control = ""

describe 'Minify', ->

  before ->
    try fs.unlinkSync "#{fixturePath}/minify/join.js"
    control = fs.readFileSync "#{fixturePath}/control/test.min.js", 'utf8'

  it 'should compile and minify a single jade file', ->

    jadebars "#{fixturePath}/minify/test.jade", minify: true
    testFile = fs.readFileSync "#{fixturePath}/minify/test.js", 'utf8'
    assert testFile.length
    assert.equal testFile, control

  after ->
    #try fs.unlinkSync "#{fixturePath}/minify/test.js"
