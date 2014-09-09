helpers = require '../../helpers.coffee'
profile = require '../../../scripts/view/profile/profile.coffee'

sinon = require 'sinon'

describe 'profile view', ->
  controller = null
  scope      = null

  beforeEach helpers.module profile.name
  beforeEach inject ($controller, $rootScope) ->
    scope      = $rootScope.$new()
    controller = $controller 'ProfileController',
      $scope: scope
      user: {}
    scope.$digest()

  describe '#validateAndStart', ->
    it 'should trigger $start on user', ->
      $start = sinon.spy()
      scope.validateAndStart { $start }
      $start.called.should.be.ok

    it 'should reroute to questions if success', inject ($state) ->
      # Call the fn straight away
      $start = (cb) -> cb()
      sinon.stub $state, 'go'
      scope.validateAndStart { $start }
      $state.go.calledWith('question').should.be.ok
      $state.go.restore()

  describe '#isAlreadyStarted', ->
    it 'should be true if user has startedAt', ->
      res = scope.isAlreadyStarted { startedAt: Date.now }
      res.should.be.ok

    it 'should be false if user has no startedAt', ->
      res = scope.isAlreadyStarted {}
      res.should.not.be.ok






