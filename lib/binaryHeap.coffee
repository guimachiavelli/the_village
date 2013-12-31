'use strict'


module.exports =

	class BinaryHeap
		
		constructor: (scoreFunction) ->
			@content = []
			@scoreFunction = scoreFunction



		push: (el) ->
			#console.log 'from bh:' + element.parent
			# Add the new element to the end of the array.
			@content.push el

			# Allow it to sink down.
			@sinkDown @content.length - 1

	  
		pop: ->
			# Store the first element so we can return it later.
			result = @content[0]

			# Get the element at the end of the array.
			end = @content.pop()

			# If there are any elements left, put the end element at the
			# start, and let it sink down.
			if @content.length > 0
				@content[0] = end
				@bubbleUp 0

			result


		remove: (node) ->
			i = @content.indexOf node

			# When it is found, the process seen in 'pop' is repeated
			# to fill up the hole.
			end = @content.pop()

			if i != @content.length - 1
				@content[i] = end
            
			if @scoreFunction(end) < @scoreFunction(node)
				@sinkDown i
			else
				@bubbleUp i

		size: () ->
			return @content.length

		rescoreElement: (node) ->
			@sinkDown @content.indexOf(node)

		sinkDown: (n) ->
			# Fetch the element that has to be sunk.
			element = @content[n]

			# When at 0, an element can not sink any further.
			while n > 0

				# Compute the parent element's index, and fetch it.
				parentN = ((n + 1) >> 1) - 1
				parent = @content[parentN]
				
				# Swap the elements if the parent is greater.
				if @scoreFunction(element) < @scoreFunction(parent)
					@content[parentN] = element
					@content[n] = parent

					# Update 'n' to continue at the new position.
					n = parentN


				#Found a parent that is less, no need to sink any further.
				else
					break


		bubbleUp: (n) ->
			# Look up the target element and its score.
			length = @content.length
			element = @content[n]
			elemScore = @scoreFunction(element)
        
			while true
				# Compute the indexes of the child elements.
				child2N = (n + 1) << 1
				child1N = child2N - 1

				# This is used to store the new position
				# of the element if any.
				swap = null
				
				# If the first child exists (is inside the array)
				if child1N < length
					# Look it up and compute its score.
					child1 = @content[child1N]
					child1Score = @scoreFunction child1

					# If the score is less than our element's, we need to swap.
					if child1Score < elemScore then swap = child1N

				# Do the same checks for the other child.
				if child2N < length
					child2 = @content[child2N]
					child2Score = @scoreFunction child2
					if child2Score < (swap is null ? elemScore : child1Score)
						swap = child2N

				# If the element needs to be moved, swap it, and continue.
				if swap isnt null
					@content[n] = @content[swap]
					@content[swap] = element
					n = swap

				# Otherwise, we are done.
				else
					break
