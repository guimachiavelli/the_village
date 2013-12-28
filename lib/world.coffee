###########################################################################
###### The Village – World ################################################
#
#
# 	the world sets the stage for the whole thing, controlling time flow
# 	and containing all the elements
#
#
###########################################################################
###########################################################################


'use strict'

tiles = require './tile.coffee'
Person = require './person.coffee'
Event = require './events.coffee'

module.exports =

	class World
		# the constructor requires a string for the village name
		# and two integers for world width and height
		constructor: (@name, @width, @height) ->
			throw new Error 'invalid width' if @width < 1
			throw new Error 'invalid height' if @height < 1
			
			@name = 'zannone' unless @name
			
			@turnCounter = 0

			# matrix is a bidimensional array that contains
			# all the locations in the world object
			# each location is an object
			@matrix = []

			# each time a character does something,
			# it pushes a string into the log array
			@log = []

			@event = new Event @

			@init()

		
		# used to set the time interval
		speed: 1000

		init: () ->
			# the init function serves mainly to populate the world matrix
			# with all the objects for location
			for [0...@height]
				@matrix.push []
			for row, i in @matrix
				for [0...@width]
					# for now, we have three properties:
					# tile: the type of terrain
					# person: any characters that may occupy the spot
					# occupied: certain objects may occupy the location,
					# 	preventing anything else to enter that spot
					@matrix[i].push {
						"tile" : tiles.grass,
						"person" : '',
						"occupied" : false
					}
		
		createTheSea: (size) ->
			# the sea is a group of water tiles that take up one corner
			# of the world, have a few lines of shallow, walkable water
			# and the rest is made of deep, non walkable water
			margin = Math.floor(size/2)
			
			while size >= 0
				for column, c in @matrix[size]
					if size - margin > 0
						@matrix[size][c].tile = tiles.shallow_water
					else
						@matrix[size][c].tile = tiles.deep_water
				size--
		

		run: (stop) ->
			# run sets an interval making a turn pass in
			# a set time interval dependend on the world's speed
			
			if stop is false
				running = setInterval () =>
					@turn()
				, @speed
			else
				clearInterval running
		
		turn: () ->
			# turn increments the world's turn counter
			# and makes each character act

			@event.calendar @turnCounter

			for row in @matrix
				for col in row
					if col.person instanceof Person
						col.person.act()
			
			@turnCounter++

		printMatrix: ->
			print = ''
			for row in @matrix
				for col in row
					if col.person instanceof Person
						print += col.person.symbol
					else
						print += col.tile.symbol
				print += '<br>'
			
			return print

