require "crsfml"

module Jasper

    class PhysicsBody < SF::Transformable

        NULL_EPSILON = 1e-3

        property direction
        property force_direction
        property inertia
        property rotation_speed
        property mass
        property scaler
        property friction_coefficient
        property inertia_momentum

        @scaler = 80.0f32
        @inertia = SF.vector2f(0.0,0.0)
        @acceleration = SF.vector2f(0.0,0.0)
        @friction_coefficient = 0.0f32
        @mass = 10.0f32
        @norm = 0.0f32
        @force_direction = SF.vector2f(0.0,0.0)
        @momentum = 0.0f32
        @inertia_momentum = 50.0f32
        @rotation_speed = 0.0f32
        @direction = SF.vector2f(0.0,-1.0)

        def initialize
            super
        end

        def apply_force(force : SF::Vector2f)
            @acceleration += force / @mass
        end

        def apply_torque(torque : Float32)
            @momentum += torque / @inertia_momentum
        end

        def compute_translation(dt : SF::Time)
            @acceleration += (-@inertia) * (@friction_coefficient/@mass)
            @inertia += @acceleration * dt.as_seconds * @scaler
            movement = @inertia * dt.as_seconds * @scaler
            self.move(movement)
            @norm = Math.sqrt((movement.x ** 2) + (movement.y ** 2))
            if(@norm > NULL_EPSILON)
                @force_direction = movement / @norm
            else 
                @force_direction = SF.vector2f(0.0,0.0)
            end
            @acceleration = SF.vector2f(0.0,0.0)
        end

        def compute_rotation(dt : SF::Time)
            @momentum += (-@rotation_speed) * (@friction_coefficient/@inertia_momentum)
            @rotation_speed += @momentum * dt.as_seconds * @scaler
            new_rotation = @rotation_speed * dt.as_seconds * @scaler
            self.rotate(new_rotation)
            rad_rotation = self.rotation * (Math::PI / 180)
            @direction = SF.vector2f(Math.sin(rad_rotation), -Math.cos(rad_rotation))
            @momentum = 0
        end

        def update_physics(dt : SF::Time)
            compute_translation(dt)
            compute_rotation(dt)
        end
         
    end

end