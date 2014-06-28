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

describe 'world structure:', ->
	
	describe 'world init() and constructor', ->
		it 'should not accept height < 0', ->
			(-> world = new World 'world', 1, 0).should.throw 'invalid height'

		it 'should not accept width < 0', ->
			(-> world = new World 'world', 0, 1).should.throw 'invalid width'

		it 'should populate the stage with tiles and people', ->
			world = new World 'world', 5, 5
			
			world.matrix[0][0].tile.exists
			world.matrix[0][0].person.exists

		it 'should make water and deep water tiles with createTheSea()', ->
			world = new World 'world', 50, 50

			size = 20
			random_shallow_row = Math.ceil(Math.random() * (size - size/2) + size/2)
			random_deep_row = Math.floor(Math.random() * size/2)

			world.createTheSea(size)
			
			world.matrix[random_shallow_row][0].tile.name.should.equal 'water'
			world.matrix[random_deep_row][5].tile.name.should.equal 'deep water'
	
	describe 'time flux with turn() and run()', ->

		it 'should count how many turns have passed', ->
			world = new World 'world', 5, 5
			
			world.turn()
			world.turnCounter.should.equal 1


		it 'should pass 10 turns', ->
			world = new World 'world', 5, 5
			number_of_turns = 10
			pass = world.speed * number_of_turns

			world.run(false)
			clock.tick pass
			world.run(true)
			
			world.turnCounter.should.equal number_of_turns


describe 'world fixtures:', ->
	
	it 'deep water tiles should not be walkable', ->
		world = new World 'world', 10, 10
		char1 = new Person 'bass', [3, 1], '@', world

		world.createTheSea(5)
		char1.move 'y', '-'
		
		char1.position.should.deep.equal [3,1]
