validateQuestion = require '../../lib/validate-question'

describe 'validate-question', ->
  it 'should return false if falsy value is given', ->
    validateQuestion(null).should.not.be.ok
    validateQuestion(false).should.not.be.ok
    validateQuestion(undefined).should.not.be.ok
    validateQuestion('').should.not.be.ok

  it 'should return false if question has null or undefined name', ->
    validateQuestion({ 'name': null }).should.not.be.ok
    validateQuestion({ 'name': undefined }).should.not.be.ok

  it 'should return false if no type is given', ->
    validateQuestion({'description', 'name'}).should.not.be.ok

  describe 'question type', ->
    type = 'question'
    it 'should return true if question has all valid fields', ->
      validateQuestion({ 'name', 'description', 'options', type }).should.be.ok

    it 'should return true if question has more fields than needed', ->
      validateQuestion({ 'name', 'description', 'XXX', 'options', type }).should.be.ok

    it 'should return false if question has less fields than needed', ->
      validateQuestion({ 'name', type }).should.not.be.ok

  describe 'code type', ->
    type = 'code'
    it 'should return true if question has all valid fields', ->
      validateQuestion({ 'name', 'description', 'code', 'options', type }).should.be.ok

    it 'should return true if question has more fields than needed', ->
      validateQuestion({ 'name', 'description', 'XXX', 'code','options', type }).should.be.ok

    it 'should return false if question has less fields than needed', ->
      validateQuestion({ 'name', type }).should.not.be.ok

  describe 'text type', ->
    type = 'text'
    it 'should return true if question has all valid fields', ->
      validateQuestion({ 'name', 'description', type }).should.be.ok

    it 'should return true if question has more fields than needed', ->
      validateQuestion({ 'name', 'description', 'XXX', type }).should.be.ok

    it 'should return false if question has less fields than needed', ->
      validateQuestion({ 'name', type }).should.not.be.ok

