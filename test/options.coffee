assert   = require 'assert'
fs       = require 'fs'
path     = require 'path'
jadebars = require '../lib/jadebars'

fixturePath = path.join __dirname, 'fixtures'

describe 'Options', ->

  before ->
    removeTestFiles()

  it 'should compile with a known helper', ->

    jadebars "#{fixturePath}/options/known.jade", {known: "knownHelper"}
    testFile = fs.readFileSync "#{fixturePath}/options/known.js", 'utf8'
    controlFile = fs.readFileSync "#{fixturePath}/control/known.js", 'utf8'
    assert.equal testFile, controlFile

  it 'should compile with a known helper array', ->

    jadebars "#{fixturePath}/options/known.jade", {known: ["knownHelper"]}
    testFile = fs.readFileSync "#{fixturePath}/options/known.js", 'utf8'
    controlFile = fs.readFileSync "#{fixturePath}/control/known.js", 'utf8'
    assert.equal testFile, controlFile

  it 'should compile with known helpers only', ->
    opts = known: "knownHelper", knownOnly: true
    jadebars "#{fixturePath}/options/known_only.jade", opts
    testFile = fs.readFileSync "#{fixturePath}/options/known_only.js", 'utf8'
    controlFile = fs.readFileSync "#{fixturePath}/control/known_only.js", 'utf8'
    assert.equal testFile, controlFile

  after ->
    removeTestFiles()

removeTestFiles = ->
  try fs.unlinkSync "#{fixturePath}/options/known.js"
  try fs.unlinkSync "#{fixturePath}/options/known_only.js"