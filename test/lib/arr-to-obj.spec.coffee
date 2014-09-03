_        = require 'lodash'
objToArr = require '../../lib/arr-to-obj'

describe 'Array to object', ->
  it 'should throw if array is not defined', ->
    (-> objToArr {}).should.throw 'No array given'

  it 'should return an object', ->
    _.isPlainObject(objToArr([])).should.be.ok

  it 'should transform array to object where the keys are indexes', ->
    res = objToArr [ 'tere', 'hello' ]
    _.keys(res).should.eql [ 1, 2 ]

  it 'should transform array to object', ->
    res = objToArr [ 'tere', 'hello' ]
    res.should.eql 1: 'tere', 2: 'hello'

