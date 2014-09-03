login = require './login/login.coffee'

lobzik = angular.module 'lobzik', [ login ].map (mod) -> mod.name
angular.bootstrap document, [ lobzik.name ]


