helpers = require '../helpers.coffee'
user    = require '../../scripts/resource/user.coffee'

describe 'user factory', ->
  beforeEach helpers.module user.name

  it 'should exist', inject (User) ->
    User.should.be.ok

  describe '#get', ->
    it 'should get /user', inject (User, $httpBackend) ->
      $httpBackend.expectGET '/api/user'
                  .respond 200
      User.get()
      $httpBackend.flush()

  describe '#start', ->
    it 'should put /user/start', inject (User, $httpBackend) ->
      $httpBackend.expectPUT '/api/user/start'
                  .respond 200
      User.start()
      $httpBackend.flush()

