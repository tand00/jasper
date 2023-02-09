require "crsfml"
require "../Physics/PhysicsBody"

module Jasper

    class Entity < PhysicsBody

        include SF::Drawable

        property health : Int32
        getter width : Float32
        getter height : Float32
        property vertices : SF::VertexArray

        def initialize(pos = SF.vector2f(0.0,0.0))
            super()
            @health = 100
            @width = 128
            @height = 128
            @vertices = SF::VertexArray.new(SF::Quads, 4)
            @vertices.append SF::Vertex.new({0, 0}, tex_coords: {0, 0})
            @vertices.append SF::Vertex.new({@width, 0}, tex_coords: {128, 0})
            @vertices.append SF::Vertex.new({@width, @height}, tex_coords: {128, 128})
            @vertices.append SF::Vertex.new({0, @height}, tex_coords: {0, 128})
            @texture = SF::Texture.from_file("src/assets/Voyager-001.png")
            @texture.smooth = true
            self.set_origin(@width / 2, @height / 2)
            @alive = true
            self.position = pos
            @body.position = sf_to_cp(self.position)
        end

        def update(dt : SF::Time)
            
        end

        def kill
            @health = 0
            self.on_death
        end

        def alive
            return @health > 0
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