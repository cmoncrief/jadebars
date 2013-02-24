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

fileStats = []
controls = []

describe 'Watch', ->

  before ->
    for file in files
      try fs.unlinkSync "#{fixturePath}/watch/#{file}.js"
 
  it 'should watch a directory of jade files', (done) ->
    
    @timeout 10000

    jadebars "#{fixturePath}/watch", {watch: true}

    touchFiles = ->
      for file in files
        input = fs.readFileSync "#{fixturePath}/watch/#{file}.jade", 'utf8'
        fileStats.push fs.statSync("#{fixturePath}/watch/#{file}.js")
        fs.writeFileSync "#{fixturePath}/watch/#{file}.jade", input
      setTimeout checkStats, 5000

    checkStats = ->
      for file, i in files
        stats = fs.statSync "#{fixturePath}/watch/#{file}.js"
        assert stats.mtime.getTime() > fileStats[i].mtime.getTime()
      done()

    setTimeout touchFiles, 1000
    

  after ->
    for file in files
      try fs.unlinkSync "#{fixturePath}/watch/#{file}.js"

