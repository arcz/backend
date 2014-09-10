_ = require 'lodash'

user      = require '../../resource/user.coffee'
questions = require '../../resource/questions.coffee'

module.exports = result = angular.module 'testlab.view.result', [
  user.name
  questions.name
  'ui.router'
  'classy'
]

ResultController = result.classy.controller
  inject: [
    '$scope'
    'user'
    'questions'
  ]
  init: ->
    @$scope.user      = @user
    @$scope.questions = @questions

  getAnswer: (question) ->
    _.last question?.answers

  isValid: (question) ->
    @getAnswer(question)?.valid

  getNumberAnswered: (questions) ->
    _.reduce questions, (sum, question) ->
      sum++ if question.answers.length
      sum
    , 0

result.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'result',
    url: '/result',
    template: require './result.tpl.html'
    resolve:
      user: [ 'User', (User) -> User.get().$promise ]
      questions: [ 'Question', (Question) -> Question.query().$promise ]
    controller: ResultController
]
