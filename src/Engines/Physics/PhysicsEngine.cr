require "./PhysicsBody"

require "chipmunk/chipmunk_crsfml"

module Jasper::Engines

    class PhysicsEngine

        property space

        @bodies = [] of PhysicsBody

        @space  = CP::Space.new

        def register(body : PhysicsBody)
            @bodies << body
            @space.add(body.body)
            @space.add(body.hitbox)
        end

        def update(dt : SF::Time)
            @space.step(dt.as_seconds)
            @bodies.each do |body|
                body.update_physics(dt)
            end
        end

    end

end