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
            @bodies.each do |body|
                @bodies.each do |body2|
                    next if body == body2
                    body.collide(body2)
                end
            end
        end

    end

end