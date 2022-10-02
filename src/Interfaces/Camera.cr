require "crsfml"

module Jasper

    class Camera

        getter view : SF::View

        def initialize(size : Tuple(Int32, Int32))
            @view = SF::View.new()
            @view.set_size(*size)
        end

        def center_on(position : SF::Vector2)
            @view.center = position
        end

        def apply(window : SF::RenderWindow)
            window.view = @view
        end

    end

end