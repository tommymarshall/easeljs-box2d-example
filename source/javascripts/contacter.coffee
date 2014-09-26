Reality = require './reality'
box2d   = require './vendor/box2d'

class Contacter
	addContactListener: (callbacks) =>
		listener = new box2d.b2ContactListener

		if callbacks.BeginContact
			listener.BeginContact = (contact) ->
				callbacks.BeginContact contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData()

		if callbacks.EndContact
			listener.EndContact = (contact) ->
				callbacks.EndContact contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData()

		if callbacks.PostSolve
			listener.PostSolve = (contact, impulse) ->
				callbacks.PostSolve contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData(), impulse.normalImpulses[0]

		Reality.world.SetContactListener(listener)

module.exports = new Contacter
