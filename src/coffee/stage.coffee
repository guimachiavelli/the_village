class World
	constructor: (@name, @width, @height) ->
		@turnCounter = 0
		@matrix = []
		@stage = []

	speed: 1

	initialize: () ->
		for [0...@height]
			@matrix.push []
		for row, i in @matrix
			for [0...@width]
				@matrix[i].push {
					"tile" : grass,
					"person" : '',
					"occupied" : false
				}
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






root = exports ? window
root.World = World
