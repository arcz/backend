state = require '../../state.coffee'

module.exports = questions = angular.module 'lobzik.view.questions', [ state.name ]

questions.config [ '$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/questions/',
      redirectTo: '/questions/1'
    .when '/questions/:id',
      template: require './questions.tpl.html'
      resolve: [ 'state', (state) -> state.get() ]
]
