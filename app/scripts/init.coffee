_     = require 'lodash'
User = require './resource/user.coffee'

module.exports = init = angular.module 'testlab.init', [
  User.name
  'ui.router'
]

init.run [ 'User', '$state', (User, $state) ->
  redirect = $state.go

  successCb = (user) ->
    path = 'login'
    path = 'question' if user.isStarted
    redirect path

  User.get().$promise.then successCb, _.partial(redirect, 'login')
]
