
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
		
describe 'person: ', ->

	it 'init() and constructor should add a character to the matrix', ->
		world = new World 'world', 5, 5
		char1 = new Person 'bass', [0, 0], '@', world
		
		world.matrix[0][0].person.name.should.equal 'bass'
		world.matrix[0][0].person.symbol.should.equal '@'
	
	it 'should set their position in the stage to occupied', ->
		world = new World 'world', 5, 5
		char1 = new Person 'bass', [0, 0], '@', world

		world.matrix[0][0].occupied.should.equal true



	describe 'look: ', ->

		it 'should return a view of their surroundings', ->
			world = new World 'world', 10, 10
			char1 = new Person 'bass', [4, 3], '@', world
			char2 = new Person 'viola', [0, 3], '#', world
			char3 = new Person 'piano', [0, 2], '$', world

			char1.look()
			char2.look()
			char3.look()
			
			char1.view.length.should.equal 12
			char1.view[0].tile.name.should.equal 'grass'
			char1.view.should.not.be.empty

			char2.view.length.should.equal 9
		
			char3.view[6].person.name.should.equal 'viola'

		it 'char1 should greet char2', ->
			world = new World 'world', 10, 10
			char1 = new Person 'bass', [1, 3], '@', world
			char2 = new Person 'viola', [0, 3], '#', world

			char1.act()

			world.log.should.include char1.greeting + char2.name
	
	describe 'move: ', ->

		it 'should occupy and vacate positions when moving', ->
			world = new World 'world', 5, 5
			char1 = new Person 'bass1', [0, 0], '@', world
			
			char1.move 'x', '+'
			world.matrix[0][1].occupied.should.be.true
			world.matrix[0][0].occupied.should.be.false

		it 'should not move beyond the stage edges', ->
			world = new World 'world', 5, 5
			char1 = new Person 'bass', [0, 0], '@', world

			char1.move('x', '-')
			char1.position.should.deep.equal [0,0]

			char1.move('y', '-')
			char1.position.should.deep.equal [0,0]


		it 'should only accept y and x as viable axis', ->
			world = new World 'world', 5, 5
			char1 = new Person 'bass', [0, 0], '@', world

			(-> char1.move('z', '+')).should.throw 'invalid axis'


		it 'should only accept + and - as viable directions', ->
			world = new World 'world', 5, 5
			char1 = new Person 'bass', [0, 0], '@', world

			(-> char1.move('x', '@')).should.throw 'invalid direction'


		it 'two characters cannot occupy the same space at the same time', ->
			world = new World 'world', 5, 5
			char1 = new Person 'bass', [0, 0], '@', world
			char2 = new Person 'viola', [0, 1], '@', world

			char1.move 'x', '+'
			char1.position.should.deep.equal [0,0]
			
		
		it 'should move only one step at a time', ->
			world = new World 'world', 160, 160
			char1 = new Person 'bass1', [0, 0], '@', world

			i = 0
			while i < 150
				char1.move 'x', '+'
				char1.move 'y', '+'
				i++

			char1.position.should.deep.equal [150, 150]
			

		describe 'direction and axis', ->
			world = new World 'axis',6,5
			char1 = new Person 'bass', [0, 0], '@', world

			it 'should move a character south', ->
				char1.move('y', '+')
				char1.position.should.deep.equal [1,0]

			it 'should move a character north', ->
				char1.move('y', '-')
				char1.position.should.deep.equal [0,0]

			it 'should move a character east', ->
				char1.move('x', '+')
				char1.position.should.deep.equal [0,1]

			it 'should move a character west', ->
				char1.move('x', '-')
				char1.position.should.deep.equal [0,0]

	describe 'moveTo: ', ->
		it 'should instantly move a person to a location', ->
			world = new World 'axis', 6, 5
			char1 = new Person 'bass', [0, 0], '@', world

			char1.moveTo([4,2])
			
			char1.position.should.deep.equal [4, 2]

		it 'should throw an error if desired location does not exist', ->
			world = new World 'axis', 6, 5
			char1 = new Person 'bass', [0, 0], '@', world

			(-> char1.moveTo([14,2])).should.throw 'this location does not exist'

	describe 'moveToTarget: ', ->
		it 'should move a person to a location turn by turn', ->
			world = new World 'axis', 6, 5
			char1 = new Person 'bass', [0, 0], '@', world

			char1.moveToTarget([4,2])

			world.turn()
			world.turn()
			world.turn()
			world.turn()
			world.turn()
			world.turn()

			
			char1.position.should.deep.equal [4, 2]


	describe 'continuous action: ', ->
		it 'walk should move a character', ->
			world = new World 'axis',6,5
			char1 = new Person 'bass', [0, 0], '@', world

			char1.walk('x', '+', 4)

			world.turn()
			world.turn()
			world.turn()
			world.turn()
			
			char1.position.should.deep.equal [0, 4]
			
	

