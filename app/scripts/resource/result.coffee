module.exports = result = angular.module 'testlab.result', [ 'ngResource' ]

result.factory 'Result', [ '$resource', ($resource) ->
  $resource '/api/result', { },
    get:
      method: 'GET'
      cache: true
      isArray: true
]
