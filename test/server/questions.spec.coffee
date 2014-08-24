proxyquire = require 'proxyquire'
sinon      = require 'sinon'

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
