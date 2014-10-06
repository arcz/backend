_ = require 'lodash'

module.exports = (users) ->
  finished = _.filter(users, 'finishedAt').length

  total    : users.length
  finished : finished
  running  : users.length - finished
