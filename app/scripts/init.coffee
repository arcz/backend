_     = require 'lodash'
User = require './resource/user.coffee'

module.exports = init = angular.module 'testlab.init', [
  User.name
  'ui.router'
]

init.run [ 'User', '$state', (User, $state) ->
  redirect = $state.go

  successCb = (user) ->
    path = 'profile'
    path = 'question' if user.isStarted
    path = 'result' if user.finishedAt
    redirect path

  User.get successCb, _.partial(redirect, 'login')
]
