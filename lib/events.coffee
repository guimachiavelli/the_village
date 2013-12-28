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
	class Event

		constructor: (@world) ->

		calendar: (trigger)->

			if trigger is 3
				@tsunami()

		tsunami: ->
			@world.log.push 'wow. such water. very terror. amaze. so damage.'

