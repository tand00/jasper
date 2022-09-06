require "crsfml"

module Jasper

    class PhysicsBody < SF::Transformable

        @scaler = 200.0f32
        @inertia = SF.vector2f(0.0,0.0)
        @acceleration = SF.vector2f(0.0,0.0)
        @friction_coefficient = 0.5f32
        @mass = 10.0f32
        @norm = 0.0f32
        @direction = SF.vector2f(0.0,0.0)

        def initialize
            super
        end

        def apply_force(force : SF::Vector2f)
            @acceleration += force * (1/@mass)
        end

        def update_physics(dt : SF::Time)
            @acceleration +=  (-@inertia) * (@friction_coefficient/@mass)
            @inertia += @acceleration * dt.as_seconds * @scaler
            movement = @inertia * dt.as_seconds * @scaler
            self.move(movement)
            @norm = Math.sqrt((movement.x ** 2) + (movement.y ** 2))
            @direction = movement / @norm
            @acceleration = SF.vector2f(0.0,0.0)
        end
         
    end

end