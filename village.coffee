'use strict'

express = require 'express'
app = express()

routes = require './routes/routes.coffee'

app.configure ( () ->
	app.use express.bodyParser()
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'ejs'
	app.use express.static(__dirname + '/public')
	)

app.set 'view options', {layout: false}

app.get '/', routes.getIndex

app.listen 3000
