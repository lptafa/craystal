require "yaml"

module YAML
    struct Any
        def on(key)
            if val = self[key]?
                yield val
            end
        end
        def to_f
            if val = self.as_f?
                return val 
            end
            return val.to_f if val = self.as_i?
            raise Exception.new("Can't convert value to float")
        end
        def to_vec
            if val = self.as_a?
                return Vector3.new(
                    val[0].to_f,
                    val[1].to_f,
                    val[2].to_f
                )
            end
            raise Exception.new("Can't convert value to Vector3")
        end
    end
end