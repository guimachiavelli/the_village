class Person extends Element
	constructor: (@name, @position, @symbol, @world) ->
		@init()

	init: () ->
		@addToGrid @position, @, 'person', true

	move: (axis, direction, distance) ->
		
		distance = 1 unless distance?

		previous = @position.slice 0,2

		switch axis
			when 'y'
				if direction is '+'
						@position[0] = @position[0] + 1
				else if direction is '-'
						@position[0] = @position[0] - 1
				else
					throw 'invalid direction'
			when 'x'
				if direction is '+'
					@position[1] = @position[1] + 1
				else if direction is '-'
					@position[1] = @position[1] - 1
				else
					throw 'invalid direction'
			else
				throw 'invalid axis'
		

		if @checkBounds(@position)? then @position = previous

		if @world.matrix[@position[0]][@position[1]].tile.name is 'deep water'
			@position = previous
		
		if @world.matrix[@position[0]][@position[1]].occupied is true
			@position = previous
		else
			@world.matrix[previous[0]][previous[1]].person = ''
			@world.matrix[previous[0]][previous[1]].occupied = false
		
		@addToGrid @position, @, 'person', true
	

	act: (test) ->
		test = Math.floor(Math.random() * 4) if test == ''
		switch test
			when 0 then @move 'x','+'
			when 1 then @move 'y','+'
			when 2 then @move 'x','-'
			when 3 then @move 'y','-'


# for mocha testing
root = exports ? window
root.Person = Person

