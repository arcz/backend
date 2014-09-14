_ = require 'lodash'

envResource  = require './env.coffee'
sortQuestion = require '../lib/sort-question.coffee'

module.exports = questions = angular.module 'testlab.questions', [
  envResource.name
  'ngResource'
]

class TransformableQuestion
  constructor: (@Env, $resource, @$q) ->
    @Questions = $resource '/api/questions', { },
      list:
        method: 'GET'
        isArray: true
        cache: true

  # Returns the sorted questions list
  list: (successCb, errorCb) =>
    deffered = @$q.defer()

    @$q.all([
      @Questions.list().$promise
      @Env.get().$promise
    ]).then ([questions, env]) ->
      sorted = sortQuestion questions, env.groupOrder
      deffered.resolve sorted

    deffered.promise.then successCb, errorCb

questions.service 'Question', [ 'Env', '$resource', '$q', TransformableQuestion ]


