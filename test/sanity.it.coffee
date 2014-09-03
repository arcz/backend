helpers = require './test-helpers'
expect  = require 'expect'

describe 'sanity integration test', ->
  it 'should connect to db', (done) ->
    helpers.connect done

  it 'should disconnect from db', (done) ->
    helpers.connect ->
      helpers.disconnect ->
        expect(helpers.connection).toBe null
        done()

  afterEach (done) ->
    helpers.disconnect done



