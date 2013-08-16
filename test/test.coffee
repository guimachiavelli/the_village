chai = require 'chai'
sinon = require 'sinon'


chai.should()
expect = chai.expect

clock = sinon.useFakeTimers()


{ Element, Tile, Person, World } = require '../js/main.js'


describe 'world structure', ->

	it 'should count how many turns have passed', ->
		world = new World 'world', 5, 5
		world.initialize()
		world.turn()
		world.turnCounter.should.equal 1
	
	it 'should populate the stage with tiles and people', ->
		world = new World 'world', 5, 5
		world.initialize()
		world.matrix[0][0].tile.exists
		world.matrix[0][0].person.exists
	
	describe 'time', ->

		it 'should pass 10 turns', ->
			world = new World 'world', 5, 5
			world.initialize()
			world.run(false)
			clock.tick 10
			world.run(true)

			world.turnCounter.should.equal 10


		
describe 'characters', ->

	it 'should create a character and add it to the stage', ->
		world = new World 'world', 5, 5
		world.initialize()

		char1 = new Person 'bass', [0, 0], '@', world
		char1.initialize()
		world.matrix[0][0].person.name.should.equal 'bass'
		world.matrix[0][0].person.symbol.should.equal '@'
	
	it 'characters should set their position in the stage to occupied', ->
		world = new World 'world', 5, 5
		world.initialize()

		char1 = new Person 'bass', [0, 0], '@', world
		char1.initialize()

		world.matrix[0][0].occupied.should.equal true
	
	describe 'movement', ->

		it 'should occupy and vacate positions when moving', ->
			world = new World 'world', 5, 5
			world.initialize()

			char1 = new Person 'bass1', [0, 0], '@', world
			char1.initialize()
			
			char1.move 'x', '+'
			world.matrix[0][1].occupied.should.be.true
			world.matrix[0][0].occupied.should.be.false

		it 'should not move beyond the stage edges', ->
			world = new World 'world', 5, 5
			world.initialize()
			char1 = new Person 'bass', [0, 0], '@', world
			char1.move('x', '-')
			char1.position.should.deep.equal [0,0]

			char1.move('y', '-')
			char1.position.should.deep.equal [0,0]


		it 'should only accept y and x as viable axis', ->
			world = new World 'world', 5, 5
			world.initialize()
			char1 = new Person 'bass', [0, 0], '@', world
			(-> char1.move('z', '+')).should.throw 'invalid axis'


		it 'should only accept + and - as viable directions', ->
			world = new World 'world', 5, 5
			world.initialize()
			char1 = new Person 'bass', [0, 0], '@', world
			(-> char1.move('x', '@')).should.throw 'invalid direction'


		it 'two characters cannot occupy the same space at the same time', ->
			world = new World 'world', 5, 5
			world.initialize()
			
			char1 = new Person 'bass', [0, 0], '@', world
			char2 = new Person 'viola', [0, 1], '@', world

			char1.initialize()
			char2.initialize()

			char1.move 'x', '+'
			char1.position.should.deep.equal [0,0]
			
		

		describe 'direction and axis', ->
			worldAxis = new World 'axis',6,5
			worldAxis.initialize()

			char1 = new Person 'bass', [0, 0], '@', worldAxis
			char1.initialize()

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
