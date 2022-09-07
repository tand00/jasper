require "crsfml"

require "./Game"
require "./Engines/Entities/Entity"

module Jasper

	VERSION = "0.1.0"
	RESOLUTION = {1920, 1080}
	STYLE = SF::Style::Default
	TITLE = "Beyond Reach"

end

game = Jasper::Game.new(Jasper::TITLE, Jasper::RESOLUTION, Jasper::STYLE)

e = Jasper::Entity.new(SF.vector2f(500,500))
game.register(e)

force = 1.0f32
torque = 1.0f32

game.on_event do |event|

end

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

game.render do |window|

end

game.start