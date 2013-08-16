class Element
	constructor: (@world) ->
	
	addToGrid: (coord, el, type, occupy) ->
		@world.matrix[coord[0]][coord[1]][type] = el
		@world.matrix[coord[0]][coord[1]].occupied = occupy

	
	printElement: () ->
		 return '<b class="' + @name + '">' + @symbol + '</b>'


	checkBounds: (the_position) ->
		if not @world.matrix[the_position[0]]?
			return false
		else if not @world.matrix[the_position[0]][the_position[1]]?
			return false
	
	act: () ->
		return true

	defineArea: (position, radius) ->
		if position.length > 2 then return undefined
		
		around = []
		i = 1
		while i <= radius
			y_max_length = position[0]+i
			y_min_length = position[0]-i
			y_current = position[0]
			x_max_length = position[1]+i
			x_min_length = position[1]-i
			x_current = position[1]

			column_length = @world.height
			row_length = @world.width
				
			if x_max_length < row_length then around.push @world.matrix[y_current][x_max_length]
			if x_min_length >= 0 then around.push @world.matrix[y_current][x_min_length]

			if y_max_length < column_length
				around.push @world.matrix[y_max_length][x_current].name
				if x_max_length < row_length then around.push @world.matrix[y_max_length][x_max_length]
				if x_min_length >= 0 then around.push @world.matrix[y_max_length][x_min_length]

			if y_min_length >= 0
				around.push @world.matrix[y_min_length][x_current].name
				if x_max_length < row_length then around.push @world.matrix[y_min_length][x_max_length]
				if x_min_length >= 0 then around.push @world.matrix[y_min_length][x_min_length]
			
			i++
		return around

	surroundings: () ->
		@defineArea @position, 1
		
	


root = exports ? window
root.Element = Element

