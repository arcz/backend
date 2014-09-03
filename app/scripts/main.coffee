modules = [
  require './view/login/login.coffee'
].map (mod) -> mod.name

lobzik = angular.module 'lobzik', modules
angular.bootstrap document, [ lobzik.name ]


