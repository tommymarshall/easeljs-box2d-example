box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'
Reality  = require './reality'

class Stage
	constructor: ->
		@createStage()

	createStage: =>
		# Creates a new EaselJS Stage with our Arcade canvas
		@stage = new createjs.Stage config.ARCADE_CANVAS

		# Disallow sub-pixel positioning (runs faster)
		@stage.snapToPixelsEnabled = true

	add: (entity) =>
		# Adds a given entity's view to the Stage
		@stage.addChild entity.view

		# If our entity has an update method, bind
		# it to our Ticker's tick event and pass
		# the event to our entity.update handler
		createjs.Ticker.on 'tick', entity.update if entity.update

	update: (e) =>
		# Updates our stage with whatever
		# views are currently on it
		@stage.update(e)

module.exports = new Stage
