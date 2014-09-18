box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'
Reality  = require './reality'
Entity   = require './entity'

class Platform extends Entity
	# Fires upon instantiation, ie:
	#   var thing = new Platform(options)
	constructor: (options) ->
		@type = 'platform';

		@options = options
		@vertex     = []

		@createVectors()
		@createFixtureDefinition()
		@createBodyDefinition()
		@createBox2DBody()

	createVectors: =>
		# The x,y coordinates of a polygon. Ie:
		# [[0,0], [200, 0], [200, 10], [0, 10]]
		# which would build a rectangle with a
		# width of 200 and a height of 10.
		coords = [[0,0],[@options.width, 0],[@options.width, @options.height],[0, @options.height]]

		# Creates a vector point based on options
		# passed to the constructor and assigns them
		# to a collection of vectors (a vertex)
		for i in [0..coords.length-1]
			vector = new box2d.b2Vec2
			vector.Set( (coords[i][0] / config.SCALE), (coords[i][1] / config.SCALE) )

			@vertex.push vector

	hit: =>
		console.log 'hit platform'

	createFixtureDefinition: =>
		# Creates a new Box2D Fixture definition
		@fixtureDef = new box2d.b2FixtureDef

		# Need not have a density since this
		# will not be effected by gravity
		@fixtureDef.density = 0

		# Add friction to add some resistence to
		# how our Hero can roll
		@fixtureDef.friction = 0.5

		# How "bouncy" this object is. We don't
		# want a trampoline, so we keep this at 0
		@fixtureDef.restitution = 0

		# Define the shape, which will be a Polygon
		@fixtureDef.shape = new box2d.b2PolygonShape

		# Creates a shape based on the @vertex of
		# coordinates passed to the constructor
		@fixtureDef.shape.SetAsArray( @vertex, @vertex.length )

	createBodyDefinition: =>
		# Creates a new Box2D Body definition
		@bodyDef = new box2d.b2BodyDef

		# This body is Static and should not be
		# affected by gravity in our world.
		@bodyDef.type = box2d.b2Body.b2_staticBody

		# Sets the starting position, divided by the
		# scale of our game
		@bodyDef.position.Set(@options.x / config.SCALE, @options.y / config.SCALE)

		# Set some specific data for this platform
		@bodyDef.userData = @

	createBox2DBody: =>
		# We create a @body that will be added to our
		# world based on our body defintion
		@body = Reality.world.CreateBody( @bodyDef )

		# Assign the Fixture definition to that body
		@body.CreateFixture( @fixtureDef )

		# Creates a new EaselJS
		@view = new createjs.Shape

		# Creates a rectangle with a given fill color
		# and options which match our Fixture
		@view.graphics.beginFill('#000').drawRect(@options.x, @options.y, @options.width, @options.height)

module.exports = Platform
