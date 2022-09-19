require "crsfml"

require "./Game"
require "./Scene"
require "./Engines/Entities/Entity"

module Jasper

	VERSION = "0.1.0"
	RESOLUTION = {1920, 1080}
	STYLE = SF::Style::Default
	TITLE = "Beyond Reach"

end

game = Jasper::Game.new(Jasper::TITLE, Jasper::RESOLUTION, Jasper::STYLE)
scene = Jasper::Scene.new("src/assets/background-tile.png")
e = Jasper::Entity.new(SF.vector2f(500,500))
game.register(e)
game.register_scene("space", scene)
game.set_scene("space")

force = 0.2f32
torque = 0.3f32

game.update do |dt| 

	if(SF::Keyboard.key_pressed?(SF::Keyboard::Z))
		e.apply_force(e.direction * force)
	end
	if(SF::Keyboard.key_pressed?(SF::Keyboard::S))
		e.apply_force(e.direction * (-force))
	end
	if(SF::Keyboard.key_pressed?(SF::Keyboard::Q))
		e.apply_torque(-torque)
	end
	if(SF::Keyboard.key_pressed?(SF::Keyboard::D))
		e.apply_torque(torque)
	end

end

game.start