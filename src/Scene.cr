require "crsfml"

module Jasper

    class Scene

        def initialize(background_file : String) 
            # TODO : optimize background rendering !!
            @texture = SF::Texture.from_file(background_file, )
            @texture.repeated = true
            @background = SF::Sprite.new(@texture)
            width = 10 * 1024
            @background.texture_rect = SF.int_rect(0, 0, width, width)
            @background.origin = SF.vector2(width / 2, width / 2)
        end

        def do_update(dt : SF::Time)
            update(dt)
        end

        # def on_update(&u_block)

        def update(dt : SF::Time)
            
        end

        def do_render(window : SF::RenderWindow)
            render(window)
        end

        def render(window : SF::RenderWindow)
            window.draw(@background)
        end

        def leave ; end

        def enter ; end

    end

end