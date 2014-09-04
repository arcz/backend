helpers = require '../../test-helpers'

assert     = require 'assert'
_          = require 'lodash'
proxyquire = require 'proxyquire'
sinon      = require 'sinon'
mongoose   = require 'mongoose'
path       = require 'path'
clearDB    = require('mocha-mongoose') helpers.dbURL

# Require the schema
UserSchema = proxyquire '../../../server/models/user',
  '../../config/quiz': count: text: 1
  '../../config/config': admins: [ 'test@test.ee' ]

# Required for mocking purposes
questions = require '../../../server/questions'

User = mongoose.model 'User', UserSchema

describe 'User model', ->
  REQUIRED_FIELDS = null
  beforeEach -> REQUIRED_FIELDS = { 'email', 'name', 'authType' }
  before helpers.connect

  it 'should exist', ->
    User.should.be.ok

  describe 'creating a user', ->
    it 'should not add questions', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.questions.length.should.not.be.ok
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

  describe '#toJSON', ->
    it 'should hide _id', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        assert user.toJSON()._id is undefined
        done err

    it 'should hide __v', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        assert user.toJSON().__v is undefined
        done err

    it 'should set id', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.toJSON().id.should.be.ok
        done err

  describe '#start', ->
    beforeEach ->
      questions.load path.join __dirname, '../../fixtures/questions'
    afterEach questions.clear
    it 'should update given email', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.start { email: '11' }, (err, user) ->
          user.email.should.eql 11
          done err

    it 'should not update given email if empty', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.start {}, (err, user) ->
          user.email.should.eql 'email'
          done err

    it 'should not update any fields if already started', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.start {}, (err, user) ->
          oldStartedAt = user.startedAt
          user.start {}, (err, user) ->
            user.startedAt.should.eql oldStartedAt
            done err

    it 'should update given name', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.start { name: '11' }, (err, user) ->
          user.name.should.eql 11
          done err

    it 'should not update given name if empty', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.start { }, (err, user) ->
          user.name.should.eql 'name'
          done err

    it 'should add startedAt', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        assert user.startedAt is undefined
        user.start { }, (err, user) ->
          user.startedAt.should.be.ok
          done err

    it 'should fill questions', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.questions.length.should.eql 0
        user.start { }, (err, user) ->
          user.questions.length.should.eql 1
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


