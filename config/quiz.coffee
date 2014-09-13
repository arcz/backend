module.exports =
  # Questions count
  # The count may exceed actual the actual count. If that so then all the questions are returned.
  # If there are more questions than the count then randomized selection of the count is returned.
  #
  # * marks all questions that do not have group
  groups:
    'information' : 4
    'preference'  : 8
    '*'           : 8

  # Test duration (ms)
  duration: 1000 * 60 * 20

  # Dirctory of all questions
  dir : "#{process.cwd()}/questions"

