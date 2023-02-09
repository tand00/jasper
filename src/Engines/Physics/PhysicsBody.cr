require "crsfml"
require "./Hitbox"

module Jasper

    module Conversions
    extend self

        def sf_to_cp(vec : SF::Vector2f)
            return CP::Vect.new(vec.x, vec.y)
        end

        def cp_to_sf(vec : CP::Vect)
            return SF.vector2f(vec.x, vec.y)
        end
    end

    class PhysicsBody < SF::Transformable
    include Conversions

        STATIC_DT = 0.01f32

        property direction
        property mass
        property scaler
        property inertia_momentum
        property hitbox
        property collidable
        property static_body
        property body

        @scaler = 80.0f32
        @mass = 10.0f32
        @inertia_momentum = 50.0f32
        @direction = SF.vector2f(0.0,-1.0)
        @collidable = true
        @static_body = false
        @collided = false

        def initialize
            super
            @body = CP::Body.new(@mass, @inertia_momentum)
            @hitbox = CP::Shape::Poly.new(@body, [
                CP::Vect.new(-32,-32),
                CP::Vect.new(32,-32),
                CP::Vect.new(32,32),
                CP::Vect.new(-32,32)
            ])
            @hitbox.filter = CP::ShapeFilter::ALL
            @body.position = sf_to_cp(self.position)
        end

        def apply_force(force : SF::Vector2f)
            @body.force = sf_to_cp(force)
        end

        def apply_torque(torque : Float32)
            @body.torque = torque
        end

        def update_physics(dt : SF::Time)
            self.position = cp_to_sf(@body.position)
            self.rotation = @body.rotation.to_angle * (180 / Math::PI)
            self.direction = cp_to_sf(@body.rotation.rotate(CP::Vect.new(0,-1)))
        end
         
    end

end