_            = require 'lodash'
userResource = require './resource/user.coffee'
envResource  = require './resource/env.coffee'

module.exports = init = angular.module 'testlab.init', [
  envResource.name
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

init.run [ 'User', 'Env', '$state', '$rootScope', (User, Env, $state, $rootScope) ->
  User.get (user) ->
    path = 'profile'
    path = 'question' if user.isStarted
    path = 'result'   if user.finishedAt
    path = 'admin'    if user.admin
    $state.go path

  Env.get (env) ->
    $rootScope.title = env.title
]
