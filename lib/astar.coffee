BinaryHeap = require './binaryHeap.coffee'

module.exports =

	astar =
		init: (grid) ->
			new_grid = []
			x = 0
			xl = grid.length
			
			while x < xl
			
				y = 0
				yl = grid[x].length
				new_grid.push []

				while y < yl
					node =
						x: x
						y: y
						f: 0
						g: 0
						h: 0
						cost: 0
						visited: false
						closed: false
						parent: null

					new_grid[x].push node
					y++
				x++
			new_grid


		heap: ->
			new BinaryHeap (node) ->
				node.f
	

		search: (grid, start, end) ->
			stage = @init(grid)
			
			openHeap = @heap()

			openHeap.push stage[start[1]][start[0]]

			endNode = stage[end[1]][end[0]]

			while openHeap.size() > 0

				# Grab the lowest f(x) to process next
				currentNode = openHeap.pop()


				# End case: result has been found, return the traced path
				if currentNode is endNode
					curr = currentNode
					ret = []
					while curr.parent
						ret.push curr
						curr = curr.parent
						return ret.reverse()

				# Normal case: move currentNode from open to closed, process each of its neighbours
				currentNode.closed = true

				# Find all neighbours for the current node
				neighbours = @neighbours stage, currentNode

				
				i = 0
				il = neighbours.length

				while i < il
					neighbour = neighbours[i]
					i++

					console.log il

					# Not a valid node to process, skip to next neighbour
					if neighbour.closed is true then continue

					# The g score is the shortest distance from start to current node
					# We need to check if the path we have arrived at 
					# this neighbour is the shortest one we have seen yet
					gScore = currentNode.g + neighbour.cost
					beenVisited = neighbour.visited

					if !beenVisited or gScore < neighbour.g
						# Found an optimal (so far) path to this node
						# Take score for node to see how good it is
						
						console.log 91 + ':' + neighbour.y

						neighbour.visited = true
						neighbour.parent = currentNode
						neighbour.h = neighbour.h or @manhattan([neighbour.x, neighbour.y], [end.x, end.y])
						neighbour.g = gScore
						neighbour.f = neighbour.g + neighbour.h

						if !beenVisited
							# Pushing to heap will put it in proper place based on the 'f' value.
							openHeap.push neighbour
						else
							# Already seen the node, but since it has been rescored 
							# we need to reorder it in the heap
							openHeap.rescoreElement neighbour

			# No result was found
			return []



		manhattan: (pos0, pos1) ->
			d1 = Math.abs (pos1.x - pos0.x)
			d2 = Math.abs (pos1.y - pos0.y)
			d1 + d2

		neighbours: (grid, node) ->
			ret = []
			x = node.x
			y = node.y
			
			
			# west
			if grid[x-1]? and grid[x-1][y]? then ret.push grid[x-1][y]

			# east
			if grid[x+1]? and grid[x+1][y]? then ret.push grid[x+1][y]

			# south
			if grid[x]? and grid[x][y-1]? then ret.push grid[x][y-1]

			# north
			if grid[x]? and grid[x][y+1]? then ret.push grid[x][y+1]
			
			console.log ret

			return ret
