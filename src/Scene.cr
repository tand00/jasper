require "crsfml"
require "./GameProcess"
require "./Game"
require "./Engines/GameEngine"

module Jasper

    class Scene < GameProcess

        def initialize(background_file : String) 
            # TODO: optimize background rendering !!
            @engine = Engines::GameEngine.new
			#@camera = SF::View.new(SF.float_rect(0,0,res[0],res[1]))
            @texture = SF::Texture.from_file(background_file, )
            @texture.repeated = true
            @background = SF::Sprite.new(@texture)
            width = 10 * 1024
            @background.texture_rect = SF.int_rect(0, 0, width, width)
            @background.origin = SF.vector2(width / 2, width / 2)
        end

        def register(x : Jasper::Engines::Registrable)
			@engine.register(x)
		end

        def do_update(dt : SF::Time)
            super
            @engine.update(dt)
        end

        def do_render(window : SF::RenderWindow)
            window.draw(@background)
            super
            @engine.render(window)
        end

        def leave ; end

        def enter ; end

    end

end