helpers = require '../../helpers.coffee'
profile = require '../../../scripts/view/profile/profile.coffee'

sinon = require 'sinon'

describe 'profile view', ->
  controller = null
  scope      = null

  beforeEach helpers.module profile.name
  beforeEach inject ($controller, $rootScope, $httpBackend) ->
    $httpBackend.whenGET('/api/user').respond 200
    scope      = $rootScope.$new()
    controller = $controller 'ProfileController',
      $scope: scope
    scope.$digest()
    $httpBackend.flush()

  describe '#validateAndStart', ->
    it 'should trigger $start on user', ->
      $start = sinon.spy()
      scope.validateAndStart { $start }
      $start.called.should.be.ok

    it 'should reroute to /questions if success', inject ($location, $httpBackend) ->
      $httpBackend.expectPUT('/api/user/start').respond 200
      scope.validateAndStart scope.user
      $httpBackend.flush()
      $location.path().should.eql '/questions'

    it 'should not reroute if fails', inject ($location, $httpBackend) ->
      $httpBackend.expectPUT('/api/user/start').respond 400
      scope.validateAndStart scope.user
      $httpBackend.flush()
      $location.path().should.not.eql '/questions'


  describe '#isAlreadyStarted', ->
    it 'should be true if user has startedAt', ->
      res = scope.isAlreadyStarted { startedAt: Date.now }
      res.should.be.ok

    it 'should be false if user has no startedAt', ->
      res = scope.isAlreadyStarted {}
      res.should.not.be.ok






