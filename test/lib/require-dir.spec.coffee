sinon      = require 'sinon'
fs         = require 'fs'
path       = require 'path'
requireDir = require '../../lib/require-dir'
_          = require 'lodash'

FIXTURE_DIR = path.join __dirname, '../../test/fixtures/requireTest/'

describe 'require-dir', ->
  it 'should find all the files in a directory', sinon.test ->
    @stub(fs, 'readdirSync').returns []
    requireDir 'test'
    fs.readdirSync.calledWith('test').should.be.ok

  it 'should try to require js file', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.js' ]
    res = requireDir FIXTURE_DIR
    Object.keys(res).length.should.eql 1

  it 'should try to require json file', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.json' ]
    res = requireDir FIXTURE_DIR
    Object.keys(res).length.should.eql 1

  it 'should try to require coffee file', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.coffee' ]
    res = requireDir FIXTURE_DIR
    Object.keys(res).length.should.eql 1

  it 'should return plain object', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.json' ]
    res = requireDir FIXTURE_DIR
    _.isPlainObject(res).should.be.ok

  it 'should have module name as a key', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.json' ]
    res = requireDir FIXTURE_DIR
    res['requireTest.json'].should.be.ok

  it 'should ignore any other types', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.xxx' ]
    (-> requireDir FIXTURE_DIR).should.not.throw

  it 'should ignore files that match the ignore statement', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.coffee' ]
    res = requireDir FIXTURE_DIR, ignore: /requireTest/
    Object.keys(res).length.should.eql 0

  it 'should ignore files that match the ignore statements', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.coffee' ]
    res = requireDir FIXTURE_DIR, ignore: [ 'hello', /requireTest/ ]
    Object.keys(res).length.should.eql 0
