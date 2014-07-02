box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'

class Reality
	constructor: ->
		@createPhysics()
		@createArcadeCanvas()
		@createDebugCanvas()

	createArcadeCanvas: =>
		@arcade        = config.ARCADE_CANVAS
		@arcade.width  = config.WIDTH
		@arcade.height = config.HEIGHT

	createPhysics: =>
		# Adds gravity to world, no horizontal
		# gravity, but 50 pixel vertical gravity
		gravity = new box2d.b2Vec2 0, 50

		# Creates our Box2D World. CREATION!
		@world  = new box2d.b2World gravity, true

	createDebugCanvas: =>
		# Gets our Debug canvas
		@debug = {}
		@debug.canvas        = config.DEBUG_CANVAS
		@debug.canvas.width  = config.WIDTH
		@debug.canvas.height = config.HEIGHT
		@debug.ctx           = @debug.canvas.getContext '2d'

		# Pronounced Draw-er, this is what our
		# Box2D bodies get drawn to
		@drawer = new box2d.b2DebugDraw
		@drawer.SetSprite @debug.ctx
		@drawer.SetDrawScale config.SCALE

		# Set opacity of the bodies being drawn
		@drawer.SetFillAlpha 0.3

		# Some default parameters
		@drawer.SetFlags box2d.b2DebugDraw.e_shapeBit | box2d.b2DebugDraw.e_jointBit

		# Set our world's drawer object
		@world.SetDebugDraw @drawer

module.exports = new Reality