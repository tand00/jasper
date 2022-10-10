require "crsfml"
require "./Hitbox"

module Jasper

    class PhysicsBody < SF::Transformable

        NULL_EPSILON = 1e-3
        STATIC_DT = 1 / 100

        property direction
        property force_direction
        property inertia
        property rotation_speed
        property mass
        property scaler
        property friction_coefficient
        property inertia_momentum
        property hitbox
        property collidable
        property static_body

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
        @collidable = true
        @static_body = false

        def initialize
            @hitbox = Hitbox.new(self, [
                SF.vector2f(32,32),
                SF.vector2f(96,32),
                SF.vector2f(96,96),
                SF.vector2f(32,96)
            ])
            super
        end

        def apply_force(force : SF::Vector2f)
            @acceleration += force / @mass
        end

        def apply_speed(speed : SF::Vector2f)
            @acceleration += speed / (STATIC_DT * @scaler)
        end

        def apply_torque(torque : Float32)
            @momentum += torque / @inertia_momentum
        end

        def compute_translation(dt : SF::Time)
            @acceleration += (-@inertia) * (@friction_coefficient/@mass)
            @inertia += @acceleration * STATIC_DT * @scaler
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
            @rotation_speed += @momentum * STATIC_DT * @scaler
            new_rotation = @rotation_speed * dt.as_seconds * @scaler
            self.rotate(new_rotation)
            rad_rotation = self.rotation * (Math::PI / 180)
            @direction = SF.vector2f(Math.sin(rad_rotation), -Math.cos(rad_rotation))
            @momentum = 0
        end

        def collide(other : PhysicsBody)
            return unless (hitbox = @hitbox) && (o_hitbox = other.hitbox)
            return unless @collidable
            return unless other.collidable
            return if @static_body
            collision_dir = hitbox.get_collision_direction(o_hitbox)
            return unless collision_dir
            incoming_speed = collision_dir.x * @inertia.x + collision_dir.y * @inertia.y
            other_speed = -(collision_dir.x * other.inertia.x + collision_dir.y * other.inertia.y)
            if other.static_body
                apply_speed(collision_dir * (-incoming_speed) * 2)
                return
            end
            total_speed = incoming_speed + other_speed
            mass_ratio = self.mass / other.mass
            #puts total_speed
            apply_speed(collision_dir * (-total_speed) / mass_ratio)
            return
            # a = (1 + mass_ratio)
            # b = 2 * (other_speed - incoming_speed * mass_ratio)
            # c = (mass_ratio - 1) * (incoming_speed ** 2) - 2 * incoming_speed * other_speed
            # sqrt_delta = Math.sqrt( (b ** 2) - 4 * a * c )
            # x = (-b + sqrt_delta) / (2 * a)
            # x = (-b - sqrt_delta) / (2 * a) if x < 0
            # apply_speed(collision_dir * (-x) * 2)
            # return
        end

        def update_physics(dt : SF::Time)
            compute_translation(dt)
            compute_rotation(dt)
        end
         
    end

end