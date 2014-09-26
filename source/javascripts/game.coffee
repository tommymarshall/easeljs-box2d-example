config   = require './config'
createjs = require 'createjs'
Stats    = require 'stats'

# We only have a single Reality, Scene,
# and Stage. Once they are called here
# all subsequent require's will use
# that instance.
Contacter = require './contacter'
Reality   = require './reality'
Scene     = require './scene'
Stage     = require './stage'

class Game
	constructor: ->
		# Same default values
		@play      = true
		@showDebug = true
		@fps       = 60

		@bindEvents()
		@run()

		@setupStats() if config.SHOW_FPS

		Contacter.addContactListener
			# Before Box2d calculates how the
			# objects should respond to eachother
			BeginContact: (thingA, thingB, impulse) ->
				if impulse < 0.1 then return

				# Collides with Coin
				if thingA.type is 'hero' and thingB.type is 'coin' then Stage.remove(thingB)

			# Gets called after default phyics are applied.
			# Notice, if the object our hero is colliding with
			# is a sensor, then there would be no Physics to
			# solves and this would never fire
			PostSolve: (thingA, thingB, impulse) ->
				if impulse < 0.1 then return

	bindEvents: =>
		# Pause when window is blurred
		window.addEventListener 'blur', @setPaused

		# Play when window is focused
		window.addEventListener 'focus', @setPlay

		# Toggle showing/hiding of the Debug <canvas>
		document.getElementById('toggle-debug').onclick = @toggleDebug

	setupStats: =>
		# Uses https://github.com/mrdoob/stats.js
		@stats = new Stats
		@stats.setMode(0)
		@stats.domElement.style.position = 'absolute';
		@stats.domElement.style.right = '0px';
		@stats.domElement.style.top = '0px';
		document.body.appendChild @stats.domElement

	toggleDebug: =>
		@showDebug = !@showDebug

		# Shows/hides our Debug canvas
		Reality.debug.canvas.style.display = (if @showDebug then 'block' else 'none')

	setPlay: =>
		@play = true
		createjs.Ticker.setPaused false

	setPaused: =>
		@play = false
		createjs.Ticker.setPaused true

	run: =>
		# Set our Frames Per Second to @fps
		createjs.Ticker.setFPS @fps

		# User RequestAnimationFrame
		createjs.Ticker.useRAF = true

		# Fire @update upon each tick event
		createjs.Ticker.on 'tick', @update

	update: (e) =>
		if @play
			# Start counting for FPS stats
			@stats.begin() if config.SHOW_FPS

			# Update our Stage
			Stage.update(e.delta)

			# Our Box2D world should "step" at the
			# same rate as our defined FPS.
			Reality.world.Step 1/@fps, 10, 10

			# Set our Stage camera to follow our Hero
			Stage.follow Scene.hero

			# Show Debug drawings if enabled
			@drawDebug(e) if @showDebug

			# End counting for FPS stats
			@stats.end() if config.SHOW_FPS

	drawDebug: (e) =>
		# Save the current state/objects
		Reality.debug.ctx.save()

		# Offset the context of the canvas to match
		# the current stage's offset
		Reality.debug.ctx.translate(Stage.stage.x, Stage.stage.y)

		# Clear the previously drawn objects off the
		# screen. Note, clears a rectangle of the canvas
		# with a given x, y, width and height
		Reality.debug.ctx.clearRect(-2000, -4400, 10000, 10000)

		# Get the draw-er instance and set it to Box2D's
		# SetDebugDraw function
		Reality.world.SetDebugDraw(Reality.drawer)

		# Actually draw the items to the Debug convas
		Reality.world.DrawDebugData()

		# Restore/show the Box2D drawings
		Reality.debug.ctx.restore()

new Game
