state = require '../../state.coffee'

module.exports = profile = angular.module 'lobzik.view.profile', [
  'classy'
  state.name
]

ProfileController = profile.classy.controller

  inject: [
    '$scope'
    'state'
  ]

  init: ->
    @state.get().then (user) =>
      @$scope.user = user

  validateAndStart: (user) ->
    user.$start()

profile.config [ '$routeProvider', ($routeProvider) ->
  $routeProvider.when '/',
    template: require './profile.tpl.html'
    controller: ProfileController
    resolve: [ 'state', (state) -> state.get() ]
]
