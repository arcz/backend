resultCalc = require '../../scripts/lib/result-calc.coffee'

describe 'result calculations', ->
  it 'should return 0 if no anwsers are given', ->
    question =
      expectedAnswer: true
      coenficent: 1
      answer: {}
    res = resultCalc [ question ]
    res.should.eql 0

  it 'should return 0 if no questions are answerable', ->
    question =
      expectedAnswer: false
    res = resultCalc [ question ]
    res.should.eql 1

  it 'should return .5 if 50% of anwsers are answered', ->
    questions = [
      {
        expectedAnswer: true
        answer: {}
        coenficent: 1
      }, {
        expectedAnswer: true
        answer: valid: true
        coenficent: 1
      }
    ]
    res = resultCalc questions
    res.should.eql .5

  it 'should take coenficent to account', ->
    questions = [
      {
        expectedAnswer: true
        answer: {}
        coenficent: 2
      }, {
        expectedAnswer: true
        answer: valid: true
        coenficent: 1
      }
    ]
    res = resultCalc questions
    res.should.eql 1/3

  it 'should take coenficent to account and return 100% if all questions are correct', ->
    questions = [
      {
        expectedAnswer: true
        answer: valid: true
        coenficent: 2
      }, {
        expectedAnswer: true
        answer: valid: true
        coenficent: 1
      }
    ]
    res = resultCalc questions
    res.should.eql 1
