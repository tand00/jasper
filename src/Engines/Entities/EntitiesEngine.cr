require "crsfml"
require "./Entity"

module Jasper::Engines

    class EntitiesEngine

        include SF::Drawable

        @entities = [] of Entity

        def register(entity : Entity)
            @entities << entity
        end

        def update(dt : SF::Time)
            @entities.each do |entity|
                entity.update(dt)
            end
        end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
            @entities.each do |entity|
                entity.draw(target, states)
            end
        end

    end

end