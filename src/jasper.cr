require "crsfml"

require "./Game"
require "./Engines/Entities/Entity"

module Jasper

	VERSION = "0.1.0"
	RESOLUTION = {1920, 1080}
	STYLE = SF::Style::Default
	TITLE = "Transwarfers"

end

game = Jasper::Game.new(Jasper::TITLE, Jasper::RESOLUTION, Jasper::STYLE)

e = Jasper::Entity.new(SF.vector2f(500,500))
game.register(e)
window = game.window

game.on_event do |event|

	if event.is_a?(SF::Event::MouseButtonEvent)
		e.apply_force(SF::Mouse.get_position(window) - e.middle)
	end

end

game.update do |dt| 

end

game.render do |window|

end

game.start