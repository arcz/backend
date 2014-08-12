Stream = require('stream').Stream
module.exports = class UserArrayFormatter extends Stream
  writable: true
  _done: false

  write: (doc) ->
    unless @_hasWritten
      @_hasWritten = true
      @emit 'data', '{ "data": [' +  doc
    else
      @emit 'data', ',' + doc
    return true

  destroy: ->
    return if @_done
    User.count {}, (err, count) =>
      @_done = true
      @emit 'data', '], "total":' + count + '}'
      @emit 'end'

  end: @::destroy

