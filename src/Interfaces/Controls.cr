require "crsfml"

module Jasper

    class Controls

        def initialize(@controls_hash : Hash(Symbol, SF::Keyboard::Key))

        end

        def action?(action : Symbol) : Bool
            key = @controls_hash[action]
            return SF::Keyboard.key_pressed?(key)
        end

        def set_key(action : Symbol, key : SF::Keyboard::Key)
            @controls_hash[action] = key
        end

    end

end