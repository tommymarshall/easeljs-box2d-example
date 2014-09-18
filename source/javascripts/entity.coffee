box2d    = require './vendor/box2d'
config   = require './config'
keys     = require './keys'
createjs = require 'createjs'
Reality  = require './reality'
Stage    = require './stage'

class Entity
    destroy: =>
        id = @options.id

        if Stage.bodies[id] then Stage.stage.removeChild @view

        delete Stage.bodies[id]

        Reality.world.DestroyBody @body

module.exports = Entity
