path = require 'path'

module.exports =
  frogPath:
    title: "Path to frogs"
    description: "The path to your rare frogs"
    type: "string"
    default: path.join(__dirname, '../frogs/').replace(/\\/g, '/')
