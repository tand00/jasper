require "crsfml"

module Jasper

    class GameProcess

        def on_update(&u_block : SF::Time -> )
            @update_block = u_block
        end

        def update(dt : SF::Time) ; end

        def do_update(dt : SF::Time)
            update(dt)
            if u_block = @update_block
                u_block.call(dt)
            end
        end

        def on_render(&r_block : SF::RenderWindow -> )
            @render_block = r_block
        end

        def render(window : SF::RenderWindow) ; end

        def do_render(window : SF::RenderWindow)
            render(window)
            if r_block = @render_block
                r_block.call(window)
            end
        end

        def on_event(&block : SF::Event ->)
			@event_block = block
		end

    end

end