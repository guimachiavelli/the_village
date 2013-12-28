'use strict'

Person = require './lib/person.coffee'
World = require './lib/world.coffee'


village = new World 'nashkel', 55, 15
bass = new Person 'bass', [0, 0], '@', village
viola = new Person 'viola', [4, 0], '@', village



module.exports = village
