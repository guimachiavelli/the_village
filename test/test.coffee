chai = require 'chai'
sinon = require 'sinon'

chai.should()
expect = chai.expect

clock = sinon.useFakeTimers()


{ Element, Tile, Person, World } = require '../js/main.js'


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
			pass = world.speed * 10

			world.run(false)
			clock.tick pass
			world.run(true)

			world.turnCounter.should.equal pass


describe 'world fixtures:', ->
	
	it 'deep water tiles should not be walkable', ->
		world = new World 'world', 10, 10
		char1 = new Person 'bass', [3, 1], '@', world

		world.createTheSea(5)
		char1.move 'y', '-'
		
		char1.position.should.deep.equal [3,1]
	
		
describe 'characters', ->

	it 'should create a character and add it to the stage', ->
		world = new World 'world', 5, 5
		char1 = new Person 'bass', [0, 0], '@', world
		
		world.matrix[0][0].person.name.should.equal 'bass'
		world.matrix[0][0].person.symbol.should.equal '@'
	
	it 'characters should set their position in the stage to occupied', ->
		world = new World 'world', 5, 5
		char1 = new Person 'bass', [0, 0], '@', world

		world.matrix[0][0].occupied.should.equal true
	
	describe 'movement', ->

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


# next:
#
# buildings
# interactions -> bass talks to viola when they're on adjacent positions
# tiles -> water should not be walkable
#
# exceptions:
# 
