class app.User extends Backbone.Model
  modelName: 'user'

  url: '/api/user'

  initialize: ->
    _.bindAll @, 'updateDurLeft'
    @on 'change:id', @updateDurLeft
    app.env.on 'change:maxDuration', @updateDurLeft

  updateDurLeft: ->
    return unless @id
    clearTimeout(@durLeftTimer) if @durLeftTimer
    newDurLeft = Math.ceil (app.env.get('maxDuration') - (Date.now() - @get('startedAt').getTime())) / 1000
    newDurLeft = 0 if newDurLeft <= 0
    if @get('durationLeft') isnt newDurLeft
      @set {durationLeft: newDurLeft}, {trigger: true}
    @durLeftTimer = setTimeout(@updateDurLeft, 100) unless newDurLeft <= 0

  parse: (data, options) ->
    data.startedAt = new Date(data.startedAt)
    super data, options

assert = (args, output) ->
  throw "No user function" unless @userFun
  actual = @userFun.apply(this, args)
  if actual isnt output
    throw "For arguments #{args}: #{output} was expected, but got #{actual}"

class app.Environment extends Backbone.Model
  modelName: 'user'

  defaults:
    maxDuration: 0

  url: '/api/env'

  parse: (data, options) ->
    if data.codeAssignments
      for assignment in data.codeAssignments
        assignment.assert = assert
        assignment.testCase = _.bind eval("(" + assignment.testCase + ")"), assignment
    super data, options

app.env = new app.Environment()
app.env.fetch()
app.user = new app.User()
