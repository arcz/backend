path = require 'path'
_    = require 'lodash'

log = require '../../lib/log'

requireModule = ({ triggers }, name) ->
  try
    module   : require path.join __dirname, name
    triggers : triggers
  catch error
    log.error error

filterEmpty = ({ module, triggers } = {}) ->
  _.keys(triggers).length and _.isFunction(module)

callFn = (type) => (args...) =>
  # For each loaded module trigger the named trigger with given arguments.
  # Then call the actual notification module with the result of the trigger function.
  for { module, triggers } in @loaded when _.isFunction triggers?[type]
    module triggers[type] args...

exports.load = (config) =>
  @loaded = _(config).map requireModule
                     .filter filterEmpty
                     .value()

# Expose list of trigger methods
exports.trigger =
  finish: callFn 'finish'

