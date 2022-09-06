require "crsfml"
require "./Engines/GameEngine"

module Jasper

	class Game

		getter window

		def initialize(title, res, style)
			@videomode = SF::VideoMode.new(*res)
			@window = SF::RenderWindow.new(@videomode, title, style)
			@engine = Engines::GameEngine.new
		end

		def update(&block : SF::Time ->)
			@update_block = block
		end

		def render(&block : SF::RenderWindow ->)
			@render_block = block
		end

		def on_event(&block : SF::Event ->)
			@event_block = block
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

		private def do_update(dt : SF::Time)
			while event = @window.poll_event
				if event.is_a?(SF::Event::Closed) ; @window.close ; end
				if e_block = @event_block
					e_block.call(event)
				end
			end
			@engine.update(dt)
			if u_block = @update_block
				u_block.call(dt)
			end
		end

		private def do_render
			@window.clear(SF::Color::Black)
			@engine.render(@window)
			if r_block = @render_block
				r_block.call(@window)
			end
			@window.display
		end

	end

end