require "crsfml"

module Jasper

    class Hitbox < SF::Transformable

        def initialize(@points : Array(SF::Vector2f))
            super
        end

        def get_points
            return @points.map do |point|
                self.transform().transform_point(point)
            end
        end

        def each_segment
            points = self.get_points()
            pre = points[0]
            points[1..].each do |point|
                yield pre, point
                pre = point
            end
            yield pre, points[0]
        end

        def check_for_collision_point(other) : (Vector2f | Nil)
            self.each_segment do |p1,p2|
                p1.x += 1 if p1.x == p2.x
                a = (p2.y - p1.y) / (p2.x - p1.x)
                b = p1.y - a * p1.x
                x_range_1 = (p1.x..p2.x)
                other.each_segment do |p3,p4|
                    p3.x += 1 if p3.x == p4.x
                    c = (p4.y - p3.y) / (p4.x - p3.x)
                    d = p3.y - c * p3.x
                    x_range_2 = (p3.x..p4.x)
                    a += 1 if a == c
                    x_inter = (b - d) / (c - a)
                    next unless x_range_1.includes?(x_inter)
                    next unless x_range_2.includes?(x_inter)
                    collision_point = SF.vector2f(x_inter, a * x_inter + b)
                    return 
                end
            end
            return nil
        end

        def get_collision_direction(other)
            point = check_for_collision_point(other)
            return unless point
            vec = point - other.position
            norm = Math.sqrt((vec.x ** 2) + (vec.y ** 2))
            dir = vec / norm
            return dir
        end

    end

end