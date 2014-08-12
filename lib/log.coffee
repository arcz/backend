_     = require 'lodash'
chalk = require 'chalk'

exports.log     = console.log
exports.warn    = _.partial console.warn, chalk.yellow "Warning:"
exports.success = _.partial @log, chalk.green "Success:"
