module.exports = questions = angular.module 'testlab.questions', [ 'ngResource' ]

questions.factory 'Question', [ '$resource', ($resource) ->
  $resource '/api/questions', { },
    list:
      method: 'GET'
      isArray: true
      cache: true
]


