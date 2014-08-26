helpers = require '../../test-helpers'

_          = require 'lodash'
proxyquire = require 'proxyquire'
sinon      = require 'sinon'
mongoose   = require 'mongoose'
path       = require 'path'
clearDB    = require('mocha-mongoose') helpers.dbURL

# Require the module
proxyquire '../../../server/models/user',
  '../../config/quiz': count: text: 1
  '../../config/config': admins: [ 'test@test.ee' ]

# Required for mocking purposes
questions = require '../../../server/questions'

User = mongoose.model 'User'

describe 'User model', ->
  REQUIRED_FIELDS = null
  beforeEach -> REQUIRED_FIELDS = { 'email', 'name', 'authType'}
  before helpers.connect

  it 'should exist', ->
    User.should.be.ok

  describe 'creating a user', ->
    beforeEach ->
      questions.load path.join __dirname, '../../fixtures/questions'
    afterEach questions.clear
    it 'should add questions from built questionlist', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.questions.length.should.eql 1
        done err

  describe '#findOrCreate', ->
    it 'should return an existing user if its url is already in the system', (done) ->
      User.create REQUIRED_FIELDS, (err, oldUser) ->
        User.findOrCreate REQUIRED_FIELDS, (err, user) ->
          oldUser.id.should.eql user.id
          done err

    it 'should keep the ids the same if modifing emails when found by url', (done) ->
      oldUser = _.extend REQUIRED_FIELDS, 'email': 123
      newUser = _.extend REQUIRED_FIELDS, 'email': 321
      User.create oldUser, (err, oldUser) ->
        User.findOrCreate newUser, (err, user) ->
          oldUser.id.should.eql user.id
          done err

    it 'should modify users email if found by url and emails differ', (done) ->
      oldUser = _.extend REQUIRED_FIELDS, 'email': 123
      newUser = _.extend REQUIRED_FIELDS, 'email': 321
      User.create oldUser, (err, oldUser) ->
        User.findOrCreate newUser, (err, user) ->
          user.email.should.eql 321
          done err

    it 'should create a new user', (done) ->
      fields = _.extend REQUIRED_FIELDS, email: 'kitty'
      User.findOrCreate fields, ->
        User.findOne 'email': 'kitty', (err, user) ->
          user.should.be.ok
          done err

  describe 'admin', ->
    it 'should be true if user is in admin list', (done) ->
      email  = 'test@test.ee'
      fields = _.extend REQUIRED_FIELDS, { email }
      User.create fields, (err, user) ->
        user.admin.should.be.ok
        done err

    it 'should be false if user is not in admin list', (done) ->
      email = 'not-included'
      fields = _.extend REQUIRED_FIELDS, { email }
      User.create fields, (err, user) ->
        user.admin.should.not.be.ok
        done err

  # describe '#answer', ->
  #   it 'should return false if the user has already finished the test', ->
  #     User.create



  # describe '#isFinished', ->
  #   beforeEach ->
  #     sinon.spy User, 'finish'

    # afterEach ->
    #   User.finish.restore()

    # it 'should description', ->


