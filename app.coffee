###########################################################################
###### The Village ########################################################
#
## an attempt at a generative narrative
#
# 	current logic:
# 	app: the server, connecting logic to routing to templating
# 	village: the village logic controller
#
## 		world: the main container that sets rules such as size and flow of time
#
## 		elements: class gathering actions and helper functions
##   	common to persons, tiles and buildings
#
## 		person: the character class
#
## 		tiles: tiles work as containers for everything else (people, buildings)
#
## 		building: nothing there yet
#
#
###########################################################################
###########################################################################

'use strict'

http = require 'http'
jade = require 'jade'
express = require 'express'
app = express()

server = http.createServer app
server = server.listen 3000

io = require('socket.io').listen server


routes = require './routes/routes.coffee'
village = require './village.coffee'
village.run(false)

matrix = village.matrix

app.locals.world = village

#app.use express.favicon(__dirname + '/public/fav.png')
#app.use express.bodyParser()
app.engine 'jade', jade.__express
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.set 'view options', {layout: false}
app.use express.static(__dirname + '/public')

#io.set 'log level', 2

io.sockets.on 'connection', (socket) ->
	setInterval ->
		socket.emit('turn passed', { log: village.log, stage: village.printMatrix() })
	, 1001

	socket.on 'disconnect', () ->
		io.sockets.emit 'user disconnected'

	socket.on 'end', () ->
		io.sockets.emit 'user disconnected'



app.get '/', routes.getIndex


