module.exports = env = angular.module 'testlab.env', [ 'ngResource' ]

env.service 'Env', [ '$resource', ($resource) ->
  $resource '/env', { }, {
    get:
      method : 'GET'
      cache  : true
  }
]
