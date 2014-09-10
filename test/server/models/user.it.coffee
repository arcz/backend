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
  '../../config/quiz': count: text: 2
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

  it 'should set id', (done) ->
    User.create REQUIRED_FIELDS, (err, user) ->
      user.id.should.be.ok
      done err

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

    it 'should include virtuals', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.toJSON().isStarted.should.exist
        done err

  describe '#start', ->
    beforeEach -> questions.load path.join __dirname, '../../fixtures/questions'
    afterEach questions.clear
    it 'should update given email', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.start { email: '11' }, (err, user) ->
          user.email.should.eql 11
          done err

    it 'should update the users address', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        address = timezone: 'hello kids'
        user.start { address }, (err, user) ->
          user.address.timezone.should.eql 'hello kids'
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
          user.questions.length.should.eql 2
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

  describe '#isStarted', ->
    it 'should be true if user has startedAt', (done) ->
      fields = _.extend REQUIRED_FIELDS, { startedAt: Date.now() }
      User.create fields, (err, user) ->
        user.isStarted.should.be.ok
        done err

    it 'should be fase if user has no startedAt', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.isStarted.should.be.not.ok
        done err

  describe '#timeLeft', ->
    it 'should not exist if no startedAt', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        assert user.timeLeft is undefined
        done err

    it 'should exist if there is startedAT', (done) ->
      fields = _.extend REQUIRED_FIELDS, { startedAt: Date.now() }
      User.create fields, (err, user) ->
        user.timeLeft.should.be.ok
        done err


  describe '#timeTotal', ->
    # TODO: Add a better test
    it 'should be quizConfig duration', (done) ->
      User.create REQUIRED_FIELDS, (err, user) ->
        user.timeTotal.should.be.ok
        done err

  describe '#answer', ->
    user = null
    afterEach questions.clear
    beforeEach ->
      questions.load path.join __dirname, '../../fixtures/questions'
    beforeEach (done) ->
      User.create REQUIRED_FIELDS, (err, usr) ->
        usr.start {}, (err, startedUser) ->
          user = startedUser
          done err

    it 'should save answer', (done) ->
      question = user.questions[0]
      user.answer question.id, { content: 'tere' }, (err, answer) ->
        answer.content.should.eql 'tere'
        done err

    it 'should should save multiple answers', (done) ->
      question = _.find user.questions, { multipleAnswers: true }
      user.answer question.id, { content: 'tere' }, (err, answer) ->
        user.answer question.id, { content: 'tere' }, (err, answer) ->
          question.answers.length.should.eql 2
          done err

    it 'should not save answers if timeLeft is 0', (done) ->
      question = user.questions[0]
      sinon.stub(user, 'get').withArgs('timeLeft').returns 0
      user.answer question.id, { content: 'tere' }, (err, answer) ->
        user.get.restore()
        done answer

    it 'should return an error if timeLeft is 0', (done) ->
      question = user.questions[0]
      sinon.stub(user, 'get').withArgs('timeLeft').returns 0
      user.answer question.id, { content: 'tere' }, (err, answer) ->
        err.should.be.a.Error
        user.get.restore()
        done answer

    it 'should not save answers if questionId is invalid', (done) ->
      user.answer 'blah', { content: 'tere' }, (err, answer) ->
        done answer

    it 'should return an error if questionId is invalid', (done) ->
      user.answer 'blah', { content: 'tere' }, (err, answer) ->
        err.should.be.a.Error
        done answer

    it 'should not save answers if they are already answered and multipleAnswers is false', (done) ->
      question = _.find user.questions, { multipleAnswers: false }
      user.answer question.id, { content: 'tere' }, (err, answer) ->
        answer.should.be.ok
        user.answer question.id, { content: 'tere' }, (err, answer) ->
          done answer

    it 'should return an error when trying to save a non multiple answer for a second time', (done) ->
      question = _.find user.questions, { multipleAnswers: false }
      user.answer question.id, { content: 'tere' }, (err, answer) ->
        answer.should.be.ok
        user.answer question.id, { content: 'tere' }, (err, answer) ->
          err.should.be.a.Error
          done answer
