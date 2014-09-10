module.exports = user = angular.module 'testlab.user', [ 'ngResource' ]

user.factory 'User', [ '$resource', ($resource) ->
  $resource '/api/user', { },
    get:
      method: 'GET'
      cache: true
      isArray: false

    start:
      method: 'PUT'
      url: '/api/user/start'

    finish:
      method: 'POST'
      url: '/api/user/finish'
]
