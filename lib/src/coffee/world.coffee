'use strict'

tiles = require './tile.coffee'

module.exports =

	class World
		constructor: (@name, @width, @height) ->
			throw 'invalid width' if @width < 1
			throw 'invalid height' if @height < 1

			@turnCounter = 0
			@matrix = []
			@stage = []
			@message = '1'

			@init()

		speed: 1000

		init: () ->
			for [0...@height]
				@matrix.push []
			for row, i in @matrix
				for [0...@width]
					@matrix[i].push {
						"tile" : tiles.grass,
						"person" : '',
						"occupied" : false
					}
		
		# set the fundamental structure of the world
		# meaning, populates the tiles with diverse types of terrain
		createTheSea: (size) ->
			margin = Math.floor(size/2)
			
			while size >= 0
				for column, c in @matrix[size]
					if size - margin > 0
						@matrix[size][c].tile = tiles.shallow_water
					else
						@matrix[size][c].tile = tiles.deep_water
				size--
		

		run: (stop) ->
			_that = @
			if stop is false
				running = setInterval () ->
					_that.turn(_that)
				, @speed
			else
				clearInterval running
		
		turn: (_that) ->
			if _that? then _this = _that else _this = @
			for row in @matrix
				for col in row
					if col.person != ''
						col.person.act()

			_this.turnCounter++

		makeStage: () ->
			@stage = []
			for row, i in @matrix
				@stage.push []
				for column, y in row
					if column.person instanceof Person
						@stage[i][y] = column.person.printElement()
					else
						@stage[i][y] = column.tile.printElement()
		
		update: () ->
			#		$('#test').html('')
			@makeStage()

			#		@printStage()







#root = exports ? window
#root.World = World
