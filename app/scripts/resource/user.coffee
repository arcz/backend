module.exports = user = angular.module 'testlab.user', [ 'ngResource' ]

class CachedUser
  deffered: null
  constructor: (@$resource, @$q)->
    @User = @$resource '/api/user', { },
      start:
        method: 'PUT'
        url: '/api/user/start'

      finish:
        method: 'POST'
        url: '/api/user/finish'

  fetch: =>
    @deffered = @$q.defer()
    @User.get @deffered.resolve, @deffered.reject
    @deffered

  get: (successcb, errorcb) =>
    { promise } = @deffered or @fetch()
    promise.then successcb, errorcb

  start: -> @User.start arguments...

  finish: -> @User.finish arguments...


user.service 'User', [ '$resource', '$q', CachedUser ]
