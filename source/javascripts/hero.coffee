box2d    = require './vendor/box2d'
config   = require './config'
keys     = require './keys'
createjs = require 'createjs'
Reality  = require './reality'

class Hero
	# Some Constants
	MAX_SPEED    : 22
	JUMP_TIMEOUT : 1000 # 1 second
	JUMP_HEIGHT  : 245
	HERO_RADIUS  : 50

	constructor: ->
		# Set our Hero controls initially to false
		@controls =
			jumping  : false
			left     : false
			right    : false

		# Sets last jump time to zero, to allow
		# for jumping immediately
		@lastJumpTime = 0

		# Define the Fixture, Body, and draw the
		# View for our Hero
		@createHero()

		# Set up movement and controls
		@assignControls()

	createHero: =>
		# Define Fixture
		@fixtureDef = new box2d.b2FixtureDef

		# Give our hero a density so when
		# we jump he won't go flying away
		@fixtureDef.density = 1

		# Should respond to friction, and thus
		# will roll when on a platform
		@fixtureDef.friction = 1

		# Adds a slight bounciness to our hero
		@fixtureDef.restitution = 0.25

		# Define the shape as a circle with a
		# radius of 50 (divided by the scale)
		@fixtureDef.shape = new box2d.b2CircleShape( @HERO_RADIUS / config.SCALE )

		# Define Body
		@bodyDef = new box2d.b2BodyDef()

		# This Body is affected by gravity, so
		# it is dynamic, not static
		@bodyDef.type = box2d.b2Body.b2_dynamicBody

		# Registers certain callbacks when this
		# body is colliding with another
		@bodyDef.isSensor = true

		# Add to World
		@body = Reality.world.CreateBody( @bodyDef )
		@body.CreateFixture( @fixtureDef )

		# Disallows our Body from being disabled
		# or uncontrollable when he is not moving
		@body.SetSleepingAllowed( false )

		# Creates an EaselJS Bitmap image
		@view = new createjs.Bitmap 'images/hero.png'

		# Defines the registration points of
		# our Bitmap image, which basically
		# means the X and Y offsets
		@view.regX = @HERO_RADIUS
		@view.regY = @HERO_RADIUS

	moveToStartingPosition: =>
		# Set our Body, which is representative of
		# our Hero to...

		# A velocity of zero
		@body.SetLinearVelocity(new box2d.b2Vec2(0, 0))

		# And no spin
		@body.SetAngularVelocity(0)

		# At our starting position on the map,
		# top center
		@body.SetPosition(new box2d.b2Vec2( 20 / config.SCALE , 350 / config.SCALE ))

	assignControls: =>
		# Binds key actions
		document.onkeydown = @onControlDown
		document.onkeyup   = @onControlUp

	onControlDown: (e) =>
		# Basic switch statement to set
		# our controls to true onKeyDown
		switch e.which
			when keys.LEFT, keys.A
				@controls.left = true
			when keys.RIGHT, keys.D
				@controls.right = true
			when keys.SPACEBAR, keys.W, keys.UP
				@controls.jumping = true

	onControlUp: (e) =>
		# Basic switch statement to set
		# our controls to true onKeyUp
		switch e.which
			when keys.LEFT, keys.A
				@controls.left = false
			when keys.RIGHT, keys.D
				@controls.right = false
			when keys.SPACEBAR, keys.W, keys.UP
				@controls.jumping = false

	onGround: =>
		# If our Hero body is making contact
		# with another body, let him jump
		contacts = @body.GetContactList()
		contacts and contacts.contact.IsTouching()

	jumpTimePassed: =>
		# At least the @JUMP_TIMEOUT value has
		# passed since the last jump to disable
		# repeatable jumping.
		createjs.Ticker.getTime() - @lastJumpTime > @JUMP_TIMEOUT

	# Fires on each iteration of our Game Loop
	update: (e) =>
		# Return if game currently paused
		return if e.paused

		# Get the current position of our
		position = @body.GetPosition()

		# Get how fast
		velocity = @body.GetLinearVelocity()

		# Move our view (Our EaselJS Bitmap)
		# to the new coordinates to match the
		# Box2D Body's position of the hero
		@view.x = position.x * config.SCALE
		@view.y = position.y * config.SCALE

		# Gets the current spinning angle
		@view.rotation = @body.GetAngle() * (180 / Math.PI)

		# Set the final velocity to the current
		# velocity
		finalVelocity = velocity.x

		# If our hero falls off the map
		@moveToStartingPosition() if @view.y > config.HEIGHT

		# Jumping
		if @controls.jumping and @onGround() and @jumpTimePassed()
			# Assign the last jump time to the current
			# time of the running game
			@lastJumpTime = createjs.Ticker.getTime()

			# Apply an impulse by defining a new vector
			# point with a negative Y value -- jump height
			impulse = new box2d.b2Vec2(0, -@JUMP_HEIGHT)
			@body.ApplyImpulse(impulse, position)

		# Moving left and our Hero is moving less than the max speed
		if @controls.right and velocity.x < @MAX_SPEED
			# Add a greater velocity if rolling one
			# direction but want to move the other
			finalVelocity += (if velocity.x > 0 then 0.45 else 0.6)
		# Moving right and our Hero is moving less than the max speed
		else if @controls.left and velocity.x > -@MAX_SPEED
			# Same as above, just different direction
			finalVelocity -= (if velocity.x < 0 then 0.45 else 0.6)
		# Slowing down
		else if (Math.abs(velocity.x) > 0.015)
			# The lower this is the faster our hero
			# will slow down
			finalVelocity *= 0.96
		# Come to a stop
		else
			finalVelocity = 0

		# Set a new vector point for the hero
		# and apply the new linear velocity (left
		# and right) to our Hero's Box2D Body.
		velocity = new box2d.b2Vec2(finalVelocity, velocity.y)
		@body.SetLinearVelocity(velocity)

module.exports = Hero