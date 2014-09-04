sinon   = require 'sinon'

helpers = require './helpers.coffee'
state   = require '../scripts/state.coffee'

describe 'state', ->
  beforeEach helpers.module state.name
  beforeEach -> @sandbox = sinon.sandbox.create()
  afterEach -> @sandbox.restore()

  describe '#pull', ->
    it 'should query for user', inject (User, state)->
      sinon.spy User, 'get'
      state.pull()
      User.get.called.should.be.ok

  describe '#get', ->
    it 'should cache the result and not trigger it again', inject (User, state) ->
      sinon.spy User, 'get'
      state.get()
      state.get()
      User.get.calledOnce.should.be.ok

