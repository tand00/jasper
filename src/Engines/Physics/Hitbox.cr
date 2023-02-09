require "crsfml"

module Jasper

    class Hitbox

        include SF::Drawable

        property points
        property parent

        def initialize(@parent : SF::Transformable, @points : Array(SF::Vector2f))
  
        end

        def get_points
            return @points.map do |point|
                @parent.transform.transform_point(point)
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

        def check_for_collision_segment(other : Hitbox) #: (Tuple(SF::Vector2f,SF::Vector2f,SF::Vector2f) | Nil)
            self.each_segment do |p1,p2|
                
                mean = (p1 + p2) / 2
                abs_1 = [p1.x, p2.x]
                x_range_1 = (abs_1.min()..abs_1.max())

                other.each_segment do |p3,p4|

                    abs_2 = [p3.x, p4.x]
                    x_range_2 = (abs_2.min()..abs_2.max())

                    if p1.x == p2.x
                        if p3.x == p4.x
                            next if p1.x != p3.x
                            return {p1, p2, mean} if (p3.y - p1.y) * (p4.y - p1.y) <= 0
                            return {p1, p2, mean} if (p3.y - p2.y) * (p4.y - p2.y) <= 0
                            return {p1, p2, mean} if (p3.y - p1.y) * (p4.y - p2.y) <= 0
                            next
                        end
                        next unless x_range_2.includes?(p1.x)
                        c = (p4.y - p3.y) / (p4.x - p3.x)
                        d = p3.y - c * p3.x
                        y = c * p1.x + d
                        next unless (y - p1.y) * (y - p2.y) <= 0
                        return {p1, p2, SF.vector2f(p1.x,y)}
                    end

                    if p3.x == p4.x
                        next unless x_range_1.includes?(p3.x)
                        a = (p2.y - p1.y) / (p2.x - p1.x)
                        b = p1.y - a * p1.x
                        y = a * p3.x + b
                        next unless (y - p3.y) * (y - p4.y) <= 0
                        return {p1, p2, SF.vector2f(p3.x, y)}
                    end

                    a = (p2.y - p1.y) / (p2.x - p1.x)
                    b = p1.y - a * p1.x
                    c = (p4.y - p3.y) / (p4.x - p3.x)
                    d = p3.y - c * p3.x

                    if a == c
                        next unless b == d
                        return {p1, p2, mean} if (p3.x - p1.x) * (p4.x - p1.x) <= 0
                        return {p1, p2, mean} if (p3.x - p2.x) * (p4.x - p2.x) <= 0
                        return {p1, p2, mean} if (p3.x - p1.x) * (p4.x - p2.x) <= 0
                        next
                    end

                    x_inter = (b - d) / (c - a)
                    next unless x_range_1.includes?(x_inter)
                    next unless x_range_2.includes?(x_inter)
                    collision_point = SF.vector2f(x_inter, a * x_inter + b)

                    return {p1, p2, collision_point}
                end
            end
            return
        end

        def get_collision(other : Hitbox) : (Tuple(SF::Vector2f, Int32, SF::Vector2f) | Nil)
            collision = check_for_collision_segment(other)
            return unless collision
            p1, p2, collision_point = collision
            ortho_vec = p2 - p1
            ref = other.parent.position - collision_point
            vec = SF.vector2f(ortho_vec.y, -ortho_vec.x)
            vec *= -1 if (vec.x * ref.x + vec.y * ref.y) < 0
            norm = Math.sqrt((vec.x ** 2) + (vec.y ** 2))
            rota_dir = 1
            rota_dir = -1 if (ortho_vec.x * (-ref.x) + ortho_vec.y * (-ref.y)) < 0
            dir = vec / norm
            return {dir, rota_dir, collision_point}
        end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
            debug_shape = SF::ConvexShape.new
            points = self.get_points
            debug_shape.point_count = points.size
            points.size.times do |i|
                debug_shape[i] = points[i]
            end
            target.draw(debug_shape)
        end

    end

end