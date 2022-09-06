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
            window.draw(@entities)
        end

    end

end