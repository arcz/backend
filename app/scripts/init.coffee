_     = require 'lodash'
state = require './state.coffee'

module.exports = init = angular.module 'lobzik.init', [ state.name ]
init.run [ 'state', '$location', (state, $location) ->
  redirect = (path) ->
    $location.path path

  state.get().then _.partial(redirect, '/'),
                   _.partial(redirect, '/login')
]
