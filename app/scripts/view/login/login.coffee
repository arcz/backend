state = require '../../state.coffee'

module.exports = login = angular.module 'lobzik.view.login', [
  'ngRoute',
  state.name
]

login.config [ '$routeProvider', ($routeProvider) ->
  $routeProvider.when '/login',
    template: require './login.tpl.html'
    resolve: [ 'state', '$q', (state, $q) ->
      deffered = $q.defer()
      # If we have the state then do not allow showing the login page
      state.get().then deffered.reject, deffered.resolve
      deffered.promise
    ]
]

