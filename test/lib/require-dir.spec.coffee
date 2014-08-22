sinon      = require 'sinon'
fs         = require 'fs'
path       = require 'path'
requireDir = require '../../lib/require-dir'

fixtureDir = path.join __dirname, '../../test/fixtures'

describe 'require-dir', ->
  it 'should find all the files in a directory', sinon.test ->
    @stub(fs, 'readdirSync').returns []
    requireDir 'test'
    fs.readdirSync.calledWith('test').should.be.ok

  it 'should try to require js file', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.js' ]
    res = requireDir fixtureDir
    res.length.should.eql 1

  it 'should try to require json file', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.json' ]
    res = requireDir fixtureDir
    res.length.should.eql 1

  it 'should try to require coffee file', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.coffee' ]
    res = requireDir fixtureDir
    res.length.should.eql 1

  it 'should ignore any other types', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.xxx' ]
    (-> requireDir fixtureDir).should.not.throw

