box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'
Hero     = require './hero'
Platform = require './platform'
Reality  = require './reality'
Stage    = require './stage'

# Helper function to return a random
# integer with a lower and upper bound
randInt = (lower, upper) ->
	[lower, upper] = [0, lower]     unless upper?
	[lower, upper] = [upper, lower] if lower > upper
	Math.floor(Math.random() * (upper - lower + 1) + lower)

class Scene
	constructor: ->
		@platforms = []

		@createGround()
		@createPlatforms(10)
		@createHero()

	createGround: =>
		options =
			id     : 'ground'
			x      : -200
			y      : 590
			width  : 7000
			height : 8

		@ground = new Platform options

		# Adds the ground Platform to our Stage
		Stage.add @ground

	createPlatforms: (number) =>
		# Creates a given number of platforms
		for i in [1..number]
			options =
				id     : 'platform_' + i
				x      : i * (7000 / number) # Evenly spaced out horizontally
				y      : randInt(150, 500)
				width  : randInt(150, 350)
				height : 8

			# Creates a new Platform with given
			# options and adds them to our
			# @platforms array
			@platforms.push new Platform options

		# Adds each of our platforms to the Stage
		for platform in @platforms
			Stage.add platform

	createHero: =>
		# Creates a new Hero instance and adds
		# him to our stage
		options =
			id: 'hero'

		@hero = new Hero(options)
		Stage.add @hero

		# Moves our hero to the starting position
		@hero.moveToStartingPosition()

module.exports = new Scene
