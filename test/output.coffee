assert    = require 'assert'
fs        = require 'fs'
path      = require 'path'
jadebars  = require '../lib/jadebars'

fixturePath = path.join __dirname, 'fixtures/output'

inputFile = path.join fixturePath, 'input.jade'
outputFile = path.join fixturePath, 'input.js'
inputDir = path.join fixturePath, 'input'
outputDir = path.join fixturePath, 'output'

files = [
  "test.js"
  "test2.js"
  "sub/subtest.js"
]

describe 'Output', ->

  before ->
    try fs.unlinkSync outputFile

  it 'should write to the same directory', ->
    jadebars inputFile
    assert fs.existsSync outputFile

  it 'should write from an input dir to an output dir', ->
    jadebars inputDir, {output: outputDir}
    for file in files
      assert fs.existsSync path.join(outputDir, file)

  it 'should write from an input file to an output dir', ->
    jadebars inputFile, {output: outputDir}
    assert fs.existsSync path.join(outputDir, "input.js")

  after ->
    try fs.unlinkSync outputFile
    try fs.unlinkSync path.join(outputDir, "input.js")
    for file in files
      try fs.unlinkSync path.join(outputDir, file)
