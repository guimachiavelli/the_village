'use strict'

Element = require './elements.coffee'

class Tile extends Element
	constructor: (@name, @symbol, @deep) ->

module.exports = {
	grass: new Tile 'grass', '.'
	shallow_water: new Tile 'water', '.', false
	deep_water: new Tile 'deep water', '.', true
	tree: new Tile 'tree', '&'
}


			#	class Water extends Tile
			#		constructor: (@name, @symbol, @deep) ->
		


#grass = new Tile 'grass', '.'
#shallow_water = new Water 'water', '.', false
#deep_water = new Water 'deep water', '.', true
#tree = new Tile 'tree', '&'

#root = exports ? window
#root.Tile = Tile
