box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'
Reality  = require './reality'

class Stage
	constructor: ->
		# Array of bodies currently on stage
		@bodies = {}

		@bodiesToBeRemoved = []

		@createStage()

	createStage: =>
		# Creates a new EaselJS Stage with our Arcade canvas
		@stage = new createjs.Stage config.ARCADE_CANVAS

		# Disallow sub-pixel positioning (runs faster)
		@stage.snapToPixelsEnabled = true

	follow: (entity) =>
		# Get the current positioning of a given entity,
		# probably our Hero, and offset by 0.3 x 0.6
		@stage.x = -entity.view.x + config.WIDTH * 0.3
		@stage.y = -entity.view.y + config.HEIGHT * 0.6

	remove: (entity) =>
		@bodiesToBeRemoved.push entity

	add: (entity) =>
		# Adds a given entity's view to the Stage
		@stage.addChild entity.view
		@bodies[entity.options.id] = entity

		# If our entity has an update method, bind
		# it to our Ticker's tick event and pass
		# the event to our entity.update handler
		createjs.Ticker.on 'tick', entity.update if entity.update

	cleanUp: =>
		i = 0

		while i < @bodiesToBeRemoved.length
			@bodiesToBeRemoved[i].destroy()
			i++

		@bodiesToBeRemoved = []

	update: (e) =>
		# Remove bodies that should be removed
		@cleanUp()

		# Updates our stage with whatever
		# views are currently on it
		@stage.update(e)

module.exports = new Stage
