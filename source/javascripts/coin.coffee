box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'
Reality  = require './reality'
Entity   = require './entity'

class Coin extends Entity
	# Fires upon instantiation, ie:
	#   var thing = new Coin(options)
	constructor: (options) ->
		@type = 'coin';

		@options = options

		@createFixtureDefinition()
		@createBodyDefinition()
		@createBox2DBody()

	createFixtureDefinition: =>
		# Creates a new Box2D Fixture definition
		@fixtureDef = new box2d.b2FixtureDef

		@fixtureDef.density     = 0
		@fixtureDef.friction    = 0
		@fixtureDef.restitution = 0
		@fixtureDef.isSensor    = true

		# Define the shape, which will be a Polygon
		@fixtureDef.shape = new box2d.b2CircleShape( @options.radius / config.SCALE )

		# Creates a shape based on the @vertex of
		# coordinates passed to the constructor

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
		@view.graphics.beginFill('#f00').drawCircle(@options.x, @options.y, @options.radius)

module.exports = Coin
