assert   = require 'assert'
fs       = require 'fs'
path     = require 'path'
jadebars = require '../lib/jadebars'

fixturePath = path.join __dirname, 'fixtures'

files = [
  "test"
  "test2"
  "sub/subtest"
]

controls = []

describe 'Compile', ->

  before ->
    for file in files
      try fs.unlinkSync "#{fixturePath}/compile/#{file}.js"
      controls.push fs.readFileSync "#{fixturePath}/control/#{file}.js", 'utf8'

  it 'should compile a single jade file', ->

    jadebars "#{fixturePath}/compile/#{files[0]}.jade"
    testFile = fs.readFileSync "#{fixturePath}/compile/#{files[0]}.js", 'utf8'
    assert testFile.length
    assert.equal testFile, controls[0]


  it 'should compile a directory of jade files', ->

    jadebars "#{fixturePath}/compile"

    for file, i in files
      testFile = fs.readFileSync "#{fixturePath}/compile/#{files[i]}.js", 'utf8'
      assert testFile.length
      assert.equal testFile, controls[i]


  after ->
    for file in files
      try fs.unlinkSync "#{fixturePath}/compile/#{file}.js"

