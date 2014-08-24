dbUrl    = 'mongodb://localhost/lobzik-test'
mongoose = require 'mongoose'

describe 'sanity integration test', ->
  db = null
  it 'should connect to db', (done) ->
    db = mongoose.connect dbUrl, done

  afterEach (done) ->
    db.disconnect done



