modules = [
  require './init.coffee'
  require './view/login/login.coffee'
  require './view/profile/profile.coffee'
  require './view/questions/questions.coffee'
  require './view/small-profile/small-profile.coffee'
].map (mod) -> mod.name

angular.bootstrap document, modules
