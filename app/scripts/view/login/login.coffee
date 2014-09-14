userResource = require '../../resource/user.coffee'
envResource  = require '../../resource/env.coffee'

module.exports = login = angular.module 'testlab.view.login', [
  userResource.name
  envResource.name
  'ui.router'
  'classy'
]

LoginController = login.classy.controller
  inject: [
    '$scope'
    'env'
  ]

  init: ->
    @$scope.env = @env

  toMin: (ms) ->
    ms / 60 / 1000

login.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'login',
    url: '/login',
    template: require './login.tpl.html'
    controller: LoginController
    resolve:
      env: [ 'Env', (Env) -> Env.get().$promise ]
      user: [ 'User', '$q', (User, $q) ->
        deffered = $q.defer()
        # If we have the state then do not allow showing the login page
        User.get deffered.reject, deffered.resolve
        deffered.promise
      ]
]

