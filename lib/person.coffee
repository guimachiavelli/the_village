###########################################################################
###### The Village – Person ###############################################
#
#
# 	the person class contains the mold
# 	from which each character will be constructed
#
# 	dependant on the element class
#
#
###########################################################################
###########################################################################



'use strict'

Element = require './elements.coffee'
Pathfinder = require './pathfinder.coffee'


module.exports =
	class Person extends Element
		# the constructor takes a string for a name,
		# an array of two integers as position
		# a string with the symbol representing the character
		# and the world instance to which the person instance belongs
		constructor: (@name, @position, @symbol, @world) ->
			# view receives an array with everything that's in a
			# person's line of view when it uses the look method
			@view = null

			# hp represents the hit points of the person
			# not used so far, but will eventually be used to determine
			# whether someone lives or dies
			@hp = 10

			@greeting = 'Cheers, '

			@upcoming_action = null

			@next_move = null

			@action_queue = []
			
			@acted = false

			@duration = 0

			@init()

		init: () ->
			# for now, simply physically add a character to its world instance
			@addToGrid @position, @, 'person', true

		look: () ->
			@view = @surroundings 2

			
			

		move: (axis, direction) ->
			# the basic action, for now the default
			
			
			# stores the current position
			previous = @position.slice 0,2

			switch axis
				when 'y'
					if direction is '+'
						@position[0] = @position[0] + 1
					else if direction is '-'
						@position[0] = @position[0] - 1
					else
						throw new Error 'invalid direction'
				when 'x'
					if direction is '+'
						@position[1] = @position[1] + 1
					else if direction is '-'
						@position[1] = @position[1] - 1
					else
						throw new Error 'invalid direction'
				else
					throw new Error 'invalid axis'
			

			if @checkBounds(@position)? then @position = previous

			# our characters can't swim, so they avoid deep water
			if @world.matrix[@position[0]][@position[1]].tile.name is 'deep water'
				@position = previous
			
			if @world.matrix[@position[0]][@position[1]].occupied is true
				# if the position is marked as occupied, movement is not possible
				@position = previous
			else
				# otherwise, clear the previous location
				# and  frees the spot by setting occupied to false
				@world.matrix[previous[0]][previous[1]].person = ''
				@world.matrix[previous[0]][previous[1]].occupied = false
			

			#finally, add the character to its new spot
			@addToGrid @position, @, 'person', true

			#logs the movement
			@world.log.push @name + ': I am walking in ' + axis


		walk: (axis, direction, distance) ->
			if distance > 0
				@current_action = 'walk'
				@move axis, direction
				@duration = distance - 1
			else
				@upcoming_action = null
			

		moveToTarget: (target_pos) ->
			path = new Pathfinder @world.matrix, @position, target_pos
			for step in path
				@action_queue.push { action: 'moveTo', params: step }
			

		moveTo: (pos) ->
			console.log 'params received:' + pos
			if @world.matrix[pos[1]][pos[0]]?
				# stores the current position
				previous = @position.slice 0,2

				# otherwise, clear the previous location
				# and  frees the spot by setting occupied to false
				@world.matrix[previous[0]][previous[1]].person = ''
				@world.matrix[previous[0]][previous[1]].occupied = false
				
				@position = pos

				#finally, add the character to its new spot
				@addToGrid @position, @, 'person', true
			else
				throw new Error 'this location does not exist'


		still: () ->
			@world.log.push @name + 'wow. such useless. much nothing. amaze'

		greet: (greeted) ->
			@world.log.push @greeting + greeted


		
		act: (action, params, duration) ->

			if @action_queue.length > 0
				the_action = @action_queue.splice(0,1)
				the_action = the_action[0]
				@[the_action.action] the_action.params
				console.log 'params sent:' + the_action.params

			else if @[action]? or @upcoming_action?
				
				duration = 0 unless duration?
				params = [] unless params?


				if @upcoming_action?
					@[@upcoming_action.action] @upcoming_action.params..., @duration
				else
					@upcoming_action = { action: action, params: params }
					@[@upcoming_action.action] @upcoming_action.params..., duration

			else
				@look()

				for row in @view
					if row.person instanceof Person
						@greet row.person.name
							
				test = Math.floor(Math.random() * 5)
				switch test
					when 0 then @move 'x','+'
					when 1 then @move 'y','+'
					when 2 then @move 'x','-'
					when 3 then @move 'y','-'
					else @still
