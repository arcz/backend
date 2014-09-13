exports.group       = 'preference'
exports.type        = 'checkbox'
exports.name        = 'Choose a correct editor'
exports.description = 'from the following list choose the correct editor.'
exports.variants = {
  'vim'
  'emacs'
  'ed'
}
exports.validate = ({ vim, emacs, ed }, callback) ->
  callback null, vim and not emacs and not ed
