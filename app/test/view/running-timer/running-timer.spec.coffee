helpers = require '../../helpers.coffee'
timer   = require '../../../scripts/view/running-timer/running-timer.coffee'

sinon = require 'sinon'

describe 'running timer', ->
  compile = null
  scope   = null
  html    = '<div running-timer></div>'

  create = (tpl) ->
    el = compile(tpl) scope
    scope.$digest()
    el

  beforeEach helpers.module timer.name
  beforeEach inject ($compile, $rootScope) ->
    compile = $compile
    scope   = $rootScope.$new()

  it 'should compile to html', inject ($httpBackend) ->
    $httpBackend.expectGET('/api/user').respond 200
    elm = create html
    $httpBackend.flush()
    elm.should.be.ok

  it 'should not render anything if user is not set', inject ($httpBackend) ->
    $httpBackend.expectGET('/api/user').respond 400
    elm = create html
    $httpBackend.flush()
    elm.children().length.should.not.be.ok

  describe 'state notifiers', ->
    element = null
    beforeEach inject ($httpBackend) ->
      $httpBackend.expectGET('/api/user').respond {}
      element = create html
      $httpBackend.flush()

    it 'should be critical if there are less than 2 minutes to go', ->
      res = scope.isCritical 1*60*1000
      res.should.be.ok

    it 'should not be critical if there are more than 2minutes', ->
      res = scope.isCritical 2.5*60*1000
      res.should.not.be.ok

    it 'should be warned if there are less than 8 minutes to go', ->
      res = scope.isWarning 8*60*1000
      res.should.be.ok

    it 'should not be warned if there are more than 8 minutes', ->
      res = scope.isWarning 9*60*1000
      res.should.not.be.ok

