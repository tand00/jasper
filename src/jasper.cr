require "crsfml"

require "./Game"
require "./Scene"
require "./Engines/Entities/Entity"
require "./Interfaces/Controls"
require "./Interfaces/Camera"

module Jasper

	VERSION = "0.1.0"
	RESOLUTION = {1200, 700}
	STYLE = SF::Style::Default
	TITLE = "Beyond Reach"

end

game = Jasper::Game.new(Jasper::TITLE, Jasper::RESOLUTION, Jasper::STYLE)
scene = Jasper::Scene.new("src/assets/background-tile.png")
e = Jasper::Entity.new(SF.vector2(500,500))
e2 = Jasper::Entity.new(SF.vector2(600,600))
cam = Jasper::Camera.new(Jasper::RESOLUTION)
force = 0.1f32
torque = 0.1f32

c = Jasper::Controls.new({
	:up => SF::Keyboard::Z,
	:down => SF::Keyboard::S,
	:left => SF::Keyboard::Q,
	:right => SF::Keyboard::D,
	:break => SF::Keyboard::Space,
	:debug_up => SF::Keyboard::Up,
	:debug_down => SF::Keyboard::Down,
	:debug_left => SF::Keyboard::Left,
	:debug_right => SF::Keyboard::Right
})

scene.register(e)
scene.register(e2)
game.register_scene(:space, scene)
game.set_scene(:space)

scene.on_update do |dt|

	if(c.action?(:up))
		e.apply_force(e.direction * force)
	end
	if(c.action?(:down))
		e.apply_force(e.direction * (-force))
	end
	if(c.action?(:left))
		e.apply_torque(-torque)
	end
	if(c.action?(:right))
		e.apply_torque(torque)
	end

	if(c.action?(:debug_up))
		e.move(0,-2)
	end
	if(c.action?(:debug_down))
		e.move(0,2)
	end
	if(c.action?(:debug_left))
		e.move(-2,0)
	end
	if(c.action?(:debug_right))
		e.move(2,0)
	end

	if(c.action?(:break))
		e.friction_coefficient = 0.5
	else
		e.friction_coefficient = 0
	end

end

scene.on_render do |window|

	cam.center_on(e.position)
	cam.apply(window)

end

game.start