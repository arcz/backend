notifications = require '../../server/notifications/index'

sinon = require 'sinon'

describe 'notiications', ->
  describe '#load', ->
    it 'should should exist', ->
      notifications.load.should.be.a.Function

    it 'should not throw when given nothing', ->
      ( -> notifications.load() ).should.not.throw()

    it 'should not throw when given a module that does not exist', ->
      ( -> notifications.load 'does-not-exist': {} ).should.not.throw()

    it 'should should not add module to loaded list if it does not exist', ->
      notifications.load 'does-not-exist': {}
      notifications.loaded.should.eql []

  describe 'triggers', ->
    describe '#finish', ->
      it 'should should trigger finish method if it exists', ->
        spy = sinon.spy()
        notifications.loaded = [
          module: ->
          triggers: finish: spy
        ]
        notifications.trigger.finish 'asd'
        spy.calledWith('asd').should.be.ok

      it 'should call module with the result of finish fn', ->
        spy = sinon.spy()
        notifications.loaded = [
          module: spy
          triggers: finish: -> 'hello'
        ]
        notifications.trigger.finish 'asd'
        spy.calledWith('hello').should.be.ok
