###########################################################################
###### The Village – Pathfinder ###########################################
#
#
# 	An A* algorithm for pathfinding, making use of manhattan heuristics
# 	and binary heaps for quick searching
#
# 	largely based on A* Search/Pathfinding Algorithm from Brian Grinstead
# 	http://github.com/bgrins/javascript-astar
#
# 	dependent on BinaryHeap, modified by Grinstead, originally
# 	from Marijn Haverbeke: http://eloquentjavascript.net/appendix2.html
#
# 	Freely distributable under the MIT License.
#
###########################################################################
###########################################################################


BinaryHeap = require './binaryHeap.coffee'

module.exports =

	class Pathfinder
		constructor: (matrix, start, end) ->

			# create the grid abstraction
			@grid = @init(matrix)
			
			# initialize the heap
			@openHeap = @heap()
			
			# store the start and end nodes
			@startNode = @grid[start[1]][start[0]]
			@endNode = @grid[end[1]][end[0]]

			return @search()
			

		init: (matrix) ->
			grid = []
			x = 0
			xl = matrix.length
			
			while x < xl
			
				y = 0
				yl = matrix[x].length
				grid.push []

				while y < yl
					node = {
						x: x
						y: y
						pos: {x: x, y: y}
						f: 0
						g: 0
						h: 0
						cost: 10
						visited: false
						closed: false
						parent: null
					}
					grid[x].push node
					y++
				x++
			grid
		

		heap: ->
			new BinaryHeap (node) ->
				node.f

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

			return ret

		manhattan: (pos0, pos1) ->
			d1 = Math.abs (pos1.x - pos0.x)
			d2 = Math.abs (pos1.y - pos0.y)
			d1 + d2


		search: (matrix, start, end) ->
			
			# push start node into heap
			@openHeap.push @startNode
			
			while @openHeap.size() > 0

				# Grab the lowest f
				currentNode = @openHeap.pop()

				if currentNode is @endNode
					curr = currentNode
					ret = []
					
					while curr.parent
						ret.push [curr.y, curr.x]
						curr = curr.parent

					return ret.reverse()

				# Normal case: move currentNode from open
				# to closed, process each of its neighbours
				currentNode.closed = true

				# Find all neighbours for the current node
				neighbours = @neighbours @grid, currentNode

				i = 0
				neighbours_len = neighbours.length

				while i < neighbours_len
					neighbour = neighbours[i]
					i++

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
						neighbour.visited = true
						neighbour.parent = currentNode
						neighbour.h = neighbour.h
						neighbour.g = gScore
						neighbour.f = neighbour.g + neighbour.h

						if beenVisited is false
							# Pushing to heap will put it in proper place based on the 'f' value.
							@openHeap.push neighbour
							
						else
							# Already seen the node, but since it has been rescored
							# we need to reorder it in the heap
							@openHeap.rescoreElement neighbour

			
			# No result was found
			return []





