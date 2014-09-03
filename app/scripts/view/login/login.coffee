module.exports = login = angular.module 'login', [ 'ngRoute', 'classy' ]

login.config [ '$routeProvider', ($routeProvider) ->
  $routeProvider.when '/',
    template: require('./login.tpl.html')
]

