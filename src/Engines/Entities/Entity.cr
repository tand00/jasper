require "crsfml"
require "../Physics/PhysicsBody"

module Jasper

    class Entity < PhysicsBody

        include SF::Drawable

        property alive
        getter width : Float32
        getter height : Float32

        def initialize(pos = SF.vector2f(0.0,0.0))
            super()
            @width = 100.0
            @height = 100.0
            @vertices = SF::VertexArray.new(SF::Quads, 4)
            @vertices.append SF::Vertex.new({0, 0}, tex_coords: {0, 0})
            @vertices.append SF::Vertex.new({128, 0}, tex_coords: {128, 0})
            @vertices.append SF::Vertex.new({128, 128}, tex_coords: {128, 128})
            @vertices.append SF::Vertex.new({0, 128}, tex_coords: {0, 128})
            @texture = SF::Texture.from_file("src/assets/Voyager-001.png")
            self.set_origin(64,64)
            @alive = true
            self.position = pos
        end

        def update(dt : SF::Time)
            
        end

        def kill
            @alive = false
            self.on_death
        end

        def on_death ; end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
            states.transform *= transform
            states.texture = @texture
            target.draw(@vertices, states)
        end

        def middle
            return position + SF.vector2f(@width / 2, @height / 2)
        end

    end
    
end