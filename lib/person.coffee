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


			@action_queue = []
			
			@acted = false

			@duration = 0

			@init()


		init: () ->
			# for now, simply physically add a character to its world instance
			@addToGrid @position, @, 'person', true

		##############################
		#
		# Actions
		#
		##############################

		look: () ->
			@view = @surroundings 2


		move: (axis, direction) ->
			
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
			i = 0
			while i < distance
				@action_queue.push {action: 'move', params: [axis, direction]}
				i++

		moveToTarget: (target_pos) ->
			path = new Pathfinder @world.matrix, @position, target_pos
			for step in path
				@action_queue.push { action: 'moveTo', params: [step] }
			

		moveTo: (pos) ->
			if @world.matrix[pos[1]][pos[0]]? and
			@world.matrix[pos[1]][pos[0]].occupied isnt true
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


		still: ->
			@world.log.push @name + ' stops to ponder life\'s deepest meanings'

		greet: (greeted) ->
			@world.log.push @greeting + greeted

		plan: (action, params) ->
			if action? and params?
				@[action] params...

			else
				action = null
				params = null
				rand = Math.floor(Math.random() * 5)

				switch rand
					when 0
						action = 'move'
						params = ['x','+']
					when 1
						action = 'move'
						params = ['y','+']
					when 2
						action = 'move'
						params = ['x','-']
					when 3
						action = 'move'
						params = ['y','-']

					else
						action = 'still'
						params = []

				@action_queue.push { action, params }


		act: (action, params) ->
			@plan action, params

			if @action_queue.length > 0
				the_action = @action_queue.splice(0,1)
				the_action = the_action[0]
				@[the_action.action] the_action.params...

