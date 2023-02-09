require "./Entity"

module Jasper

    class ComposedEntity < Entity

        property parts : Array(Entity)

        def initialize()
            super
            @parts = [] of Entity
        end

        def add_part(e : Entity)
            e.hitbox.sensor = true
            @parts << e
        end

        def health
            return @parts.reduce(0) do |total, part|
                total += part.health
            end
        end

        def alive
            return @parts.any? { |e| e.alive }
        end

        def update(dt : SF::Time)
            @parts.each do |part|
                @parts.update(dt)
            end
        end

        def kill
            @parts.each do |part|
                part.kill
            end
            self.on_death
        end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
            super
            @parts.each do |part|
                part.draw(target, states)
            end
        end

    end

end