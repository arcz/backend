_            = require 'lodash'
userResource = require './resource/user.coffee'

module.exports = init = angular.module 'testlab.init', [
  userResource.name
  'ui.router'
]

init.config [ '$httpProvider', '$injector', ($httpProvider, $injector) ->
  $state = null
  $httpProvider.interceptors.push [ '$q', '$injector', ($q, $injector) ->
     'responseError': (response) ->
       if response.status is 403
         $state ?= $injector.get '$state'
         $state.go 'login'
       $q.reject response
  ]
]

init.run [ 'User', '$state', (User, $state) ->
  User.get (user) ->
    path = 'profile'
    path = 'question' if user.isStarted
    path = 'result'   if user.finishedAt
    $state.go path
]
