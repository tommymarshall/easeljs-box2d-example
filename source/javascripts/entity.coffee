box2d    = require './vendor/box2d'
config   = require './config'
keys     = require './keys'
createjs = require 'createjs'
Reality  = require './reality'
Stage    = require './stage'

class Entity
	destroy: =>
		# Destroy entity body if exists

		Reality.world.DestroyBody(@body)

		# Remove the View from the stage
		Stage.remove @options.id

module.exports = Entity
