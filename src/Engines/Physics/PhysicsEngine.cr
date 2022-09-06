require "./PhysicsBody"

module Jasper::Engines

    class PhysicsEngine

        @bodies = [] of PhysicsBody

        def register(body : PhysicsBody)
            @bodies << body
        end

        def update(dt : SF::Time)
            @bodies.each do |body|
                body.update_physics(dt)
            end
        end

    end

end