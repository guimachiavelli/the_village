
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

	describe 'tsunami: ', ->

		it 'should log tsunami event when three turns have passed', ->
			world = new World 'world', 5, 5
			number_of_turns = 4
			#			pass = world.speed * number_of_turns

			#			world.run(false)
			#			clock.tick pass
			#			world.run(true)
			
			while number_of_turns > 0
				world.turn()
				number_of_turns--
			
			world.log.should.include 'wow. such water. very terror. amaze. so damage.'
			
