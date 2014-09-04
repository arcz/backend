helpers      = require '../../helpers.coffee'
smallprofile = require '../../../scripts/view/small-profile/small-profile.coffee'

sinon = require 'sinon'

describe 'small profile view', ->
  compile = null
  scope   = null

  create = (tpl) ->
    el = compile(tpl) scope
    scope.$digest()
    el

  beforeEach helpers.module smallprofile.name
  beforeEach inject ($compile, $rootScope) ->
    compile = $compile
    scope   = $rootScope.$new()

  it 'should compile to html', inject ($httpBackend) ->
    $httpBackend.expectGET('/api/user').respond 200
    elm = create '<div small-profile></div>'
    $httpBackend.flush()
    elm.should.be.ok

  it 'should not render anything if user is not set', inject ($httpBackend) ->
    $httpBackend.expectGET('/api/user').respond 400
    elm = create '<div small-profile></div>'
    $httpBackend.flush()
    elm.children().length.should.not.be.ok

  it 'should render data if the user is set', inject ($httpBackend) ->
    $httpBackend.expectGET('/api/user').respond {}
    elm = create '<div small-profile></div>'
    $httpBackend.flush()
    elm.children().length.should.be.ok
