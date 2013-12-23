'use strict'

http = require 'http'

express = require 'express'
app = express()

server = http.createServer app
server = server.listen 3000

io = require('socket.io').listen server

jade = require 'jade'

routes = require './routes/routes.coffee'
village = require './village.coffee'
village.run(false)




#app.use express.bodyParser()
app.engine 'jade', jade.__express
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.set 'view options', {layout: false}
app.use express.static(__dirname + '/public')


io.sockets.on 'connection', (socket) ->
	setInterval =>
		socket.emit('turns passed', { turns: village.turnCounter })
	, 1000

	socket.on 'disconnect', () ->
		io.sockets.emit 'user disconnected'

	socket.on 'end', () ->
		io.sockets.emit 'user disconnected'



app.get '/', routes.getIndex


app.locals.world = village


