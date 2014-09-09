# All new test templates should go here
TEMPLATES =
  'text': require './text.tpl.html'

module.exports = questionTemplates = angular.module 'testlab.view.question.templates', []

# Put all the test templates to the cache
# Makes it easier for us to later on include them by template names
questionTemplates.run [ '$templateCache', ($templateCache) ->
  $templateCache.put name, template for name, template of TEMPLATES
]
