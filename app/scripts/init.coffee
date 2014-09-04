_     = require 'lodash'
state = require './state.coffee'

module.exports = init = angular.module 'lobzik.init', [ state.name ]
init.run [ 'state', '$location', (state, $location) ->
  redirect = (path) ->
    $location.path path

  successCb = (user) ->
    path = '/'
    path = '/questions' if user.isStarted
    redirect path

  state.get().then successCb, _.partial(redirect, '/login')
]
