###########################################################################
###### The Village – Events ###############################################
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


Person = require './person.coffee'

'use strict'

module.exports =
	event = (@trigger, @world) ->

		if @trigger is 3
			console.log 'tsunami'
			for row in @world.matrix
				for col in row
					if col.person instanceof Person
						col.person.hp -= 7
						console.log col.person.hp

		else
			console.log @trigger
