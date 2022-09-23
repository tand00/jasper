require "crsfml"
require "./GameProcess"
require "./Scene"

module Jasper

	class Game < GameProcess

		getter window

		@current_scene : Nil | Scene

		def initialize(title, res, style)
			@videomode = SF::VideoMode.new(*res)
			@window = SF::RenderWindow.new(@videomode, title, style)
			@scenes = {} of Symbol => Scene
		end

		def register_scene(name : Symbol, scene : Scene)
			@scenes[name] = scene
		end

		def set_scene(name : Symbol)
			if previous = @current_scene
				previous.leave
			end
			if scene = @scenes[name]
				@current_scene = scene
				scene.enter
			end
		end

		def start
			clock = SF::Clock.new
			while @window.open?
				dt = clock.restart
				do_update(dt)
				do_render(@window)
			end
		end

		def react_to_event(event : SF::Event)
			if event.is_a?(SF::Event::Closed) ; @window.close ; end
			if scene = @current_scene
				scene.do_event(event)
			end
		end

		def do_update(dt : SF::Time)
			scene = @current_scene
			while event = @window.poll_event
				do_event(event)
			end
			scene.do_update(dt) if scene
			super
		end

		def do_render(window)
			window.clear(SF::Color::Black)
			if scene = @current_scene
				scene.do_render(window)
			end
			super
			window.display
		end

	end

end