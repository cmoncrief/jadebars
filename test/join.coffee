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

control = ""

describe 'Join', ->

  before ->
    try fs.unlinkSync "#{fixturePath}/join/join.js"
    control = fs.readFileSync "#{fixturePath}/control/join.js", 'utf8'

  it 'should compile and join a directory of jade files', ->

    jadebars "#{fixturePath}/compile", {output: "#{fixturePath}/join/join.js" }

    joinFile = fs.readFileSync "#{fixturePath}/join/join.js", 'utf8'
    assert joinFile.length
    assert.equal joinFile, control

  after ->
    try fs.unlinkSync "#{fixturePath}/join/join.js"

