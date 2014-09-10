userResource     = require '../../resource/user.coffee'
questionResource = require '../../resource/questions.coffee'
questionView     = require './question.coffee'

_ = require 'lodash'

module.exports = questions = angular.module 'testlab.view.questions', [
  userResource.name
  questionResource.name
  questionView.name
  'classy'
  'ui.router'
]

questions.config [ '$stateProvider', ($stateProvider) ->

  # We only resolve the user
  # if it is not finished yet
  userResolve = (User, $q) ->
    deffered = $q.defer()
    User.get (user) ->
      return deffered.reject() if user.finishedAt
      deffered.resolve user
    , deffered.reject
    deffered.promise

  $stateProvider.state 'question',
      url: '/question'
      template: require './questions.tpl.html'
      controller: QuestionsController
      resolve:
        questions: [ 'Question', (Question) -> Question.list().$promise ]
        user: [ 'User', '$q', userResolve ]
]

QuestionsController = questions.classy.controller
  inject: [
    '$scope'
    '$state'
    'questions'
    'user'
  ]

  init: ->
    @$scope.questions = @questions
    @$state.go 'question.id', id: _.first(@questions).id

  isLastQuestion: ->
    id = @$state.params.id
    index = _.findIndex @questions, { id }
    index is @questions.length - 1

  finish: ->
    @user.$finish =>
      @$state.go 'result'


