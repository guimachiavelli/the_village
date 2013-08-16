class Tile extends Element
	constructor: (@name, @symbol, @color) ->

grass = new Tile('grass', '.', '#0d9')
water = new Tile('water', '.', '#000bff')
tree = new Tile('tree', '&', '#0fb')

root = exports ? window
root.Tile = Tile
