proxyquire = require 'proxyquire'
sinon      = require 'sinon'
path       = require 'path'
_          = require 'lodash'

questions = proxyquire '../../server/questions',
  '../lib/require-dir': -> requireStub arguments...
  '../lib/validate-question': -> validateQStub arguments...

requireStub   = null
validateQStub = null
describe 'questions', ->
  describe '#clear', ->
    it 'should unset the list', ->
      questions.list = 'asd'
      questions.clear()
      questions.list.should.eql []

  describe '#load', ->
    beforeEach ->
      requireStub   = sinon.stub()
      validateQStub = sinon.stub()

    afterEach questions.clear

    it 'should require all files from input directory', ->
      requireStub.returns []
      questions.load 'dir'
      requireStub.calledWith('dir').should.be.ok

    it 'should not add questions that do not pass the validator', ->
      question = [ {'test'} ]
      requireStub.returns question
      validateQStub.returns false
      questions.load 'dir'
      questions.list.should.be.eql {}

    it 'should add questions that do pass the validator', ->
      question = [ {'test'} ]
      requireStub.returns question
      validateQStub.returns true
      questions.load 'dir'
      questions.list.should.be.eql question

  describe '#getRandomQuestions', ->
    beforeEach ->
      type = "test"
      questions.list = [
        { type, "nr": 1 }
        { type, "nr": 2 }
        { type, "nr": 3 }
      ]

    afterEach questions.clear

    it 'should throw if no type is defined', ->
      (->
        questions.getRandomQuestions null
      ).should.throw "No question type defined"


    it 'should return one question by default', ->
      res = questions.getRandomQuestions "test"
      res.length.should.be.eql 1

    it 'should return the right number of questions', ->
      res = questions.getRandomQuestions "test", 3
      res.length.should.be.eql 3

    it 'should return an empty array if the type is not defined', ->
      res = questions.getRandomQuestions "does-not-exist", 12
      res.length.should.be.eql 0

  describe '#buildQuestionList', ->
    beforeEach ->
      type = "test"
      questions.list = [
        { type, "nr": 1 }
        { type, "nr": 2 }
        { type, "nr": 3 }
      ]

    afterEach questions.clear

    it 'should exist', ->
      questions.buildQuestionList.should.be.ok

    it 'should return an object', ->
      res = questions.buildQuestionList 'test': 1
      _.isPlainObject(res).should.be.ok

    it 'should return the same keys in object as asked', ->
      res = questions.buildQuestionList
        test: 1
        code: 2
      Object.keys(res).should.eql [ 'test', 'code' ]

    it 'should return each question from a count as an array', ->
      res = questions.buildQuestionList
        test: 1
        code: 2
      _.every(res, (val, key) -> _.isPlainObject val).should.be.ok

    it 'should ask getRandomQuestions by each type', sinon.test ->
      @spy questions, 'getRandomQuestions'
      res = questions.buildQuestionList
        test: 1
        code: 2
      questions.getRandomQuestions.calledTwice.should.be.ok

    it 'should ask getRandomQuestions by each type with a count', sinon.test ->
      @spy questions, 'getRandomQuestions'
      res = questions.buildQuestionList
        test: 12
      questions.getRandomQuestions.calledWith('test', 12).should.be.ok

    it 'should have ids for keys for each obj', ->
      res = questions.buildQuestionList
        test: 12
      _.every(_.keys(res.test), (val, key) -> _.isNumber key).should.be.ok
