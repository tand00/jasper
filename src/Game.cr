require "crsfml"
require "./GameProcess"
require "./Engines/GameEngine"
require "./Scene"

module Jasper

	class Game < GameProcess

		getter window

		@current_scene : Nil | Scene

		def initialize(title, res, style)
			@videomode = SF::VideoMode.new(*res)
			@window = SF::RenderWindow.new(@videomode, title, style)
			@engine = Engines::GameEngine.new
			@camera = SF::View.new(SF.float_rect(0,0,res[0],res[1]))
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

		def register(x : Jasper::Engines::Registrable)
			@engine.register(x)
		end

		def start
			clock = SF::Clock.new
			while @window.open?
				dt = clock.restart
				do_update(dt)
				do_render
			end
		end

		def do_update(dt : SF::Time)
			while event = @window.poll_event
				if event.is_a?(SF::Event::Closed) ; @window.close ; end
				if e_block = @event_block
					e_block.call(event)
				end
			end
			if scene = @current_scene
				scene.do_update(dt)
			end
			if u_block = @update_block
				u_block.call(dt)
			end
			@engine.update(dt)
		end

		def do_render
			@window.clear(SF::Color::Black)
			if scene = @current_scene
				scene.do_render(@window)
			end
			if r_block = @render_block
				r_block.call(@window)
			end
			@engine.render(@window)
			@window.display
		end

	end

end