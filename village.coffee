'use strict'

Person = require './lib/src/coffee/person.coffee'
World = require './lib/src/coffee/world.coffee'


village = new World 'nashkel', 5, 5
bass = new Person 'bass', [0, 0], '@', village
viola = new Person 'viola', [4, 0], '@', village

module.exports = village
