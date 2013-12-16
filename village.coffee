'use strict'

express = require 'express'
app = express()

routes = require './routes/routes.coffee'
World = require './lib/src/coffee/world.coffee'

test = new World 'world', 5, 5

app.configure ( () ->
	app.use express.bodyParser()
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'ejs'
	app.use express.static(__dirname + '/public')
)

app.set 'view options', {layout: false}

app.get '/', routes.getIndex


app.locals.world = test

app.listen 3000
