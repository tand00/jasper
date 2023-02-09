require "crsfml"
require "./Entities/*"
require "./Physics/*"

module Jasper::Engines

    alias Registrable = Jasper::Entity | Jasper::PhysicsBody

    class GameEngine

        def initialize
            @physics = PhysicsEngine.new
            @entities = EntitiesEngine.new
        end

        def register(x : Registrable)
            @entities.register(x) if(x.is_a?(Jasper::Entity))
            @physics.register(x) if(x.is_a?(Jasper::PhysicsBody))
        end

        def update(dt : SF::Time)
            @physics.update(dt)
            @entities.update(dt)
        end

        def render(window : SF::RenderWindow)
            debug_draw = SFMLDebugDraw.new(window, SF::RenderStates.new(
                SF::Transform.new.translate(window.size / 2).scale(1, -1).scale(5, 5)
              ))
            window.draw(@entities)
            debug_draw.draw(@physics.space)
        end

    end

end