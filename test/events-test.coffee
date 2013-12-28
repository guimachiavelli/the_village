
'use strict'

chai = require 'chai'
sinon = require 'sinon'

chai.should()
expect = chai.expect

clock = sinon.useFakeTimers()

Element = require '../lib/elements.coffee'
Tile = require '../lib/tile.coffee'
Person = require '../lib/person.coffee'
World = require '../lib/world.coffee'
Event = require '../lib/events.coffee'
		
describe 'events: ', ->

	it 'should log new event trigger', ->
		world = new World 'world', 5, 5
		#		event = new Event world.turnCounter


