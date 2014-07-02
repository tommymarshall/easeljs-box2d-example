box2d    = require './vendor/box2d'
config   = require './config'
createjs = require 'createjs'
Hero     = require './hero'
Platform = require './platform'
Reality  = require './reality'
Stage    = require './stage'

class Scene
	constructor: ->
		@platforms = []

		@createGround()
		@createPlatform()
		@createHero()

	createGround: =>
		options =
			id     : 'ground'
			x      : 100
			y      : config.HEIGHT - 10
			width  : config.WIDTH - 200
			height : 10

		@ground = new Platform options

		# Adds the ground Platform to our Stage
		Stage.add @ground

	createPlatform: =>
		options =
			id     : 'platform_1'
			x      : config.WIDTH / 2 - 75
			y      : 350
			width  : 150
			height : 10

		# Create a new platform
		platform = new Platform options

		# Add it to the our Stage
		Stage.add platform

	createHero: =>
		# Creates a new Hero instance and adds
		# him to our stage
		@hero = new Hero
		Stage.add @hero

		# Moves our hero to the starting position
		@hero.moveToStartingPosition()

module.exports = new Scene