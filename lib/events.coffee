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

'use strict'

Person = require './person.coffee'
utils = require './utils.coffee'

module.exports =
	class Event

		constructor: (@world) ->

		calendar: (trigger)->

			if trigger is 3
				@tsunami()

		tsunami: ->
			@world.log.push 'wow. such water. very terror. amaze. so damage.'

