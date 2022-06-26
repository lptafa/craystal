struct Vector3
  property x : Float64 = 0.0
  property y : Float64 = 0.0
  property z : Float64 = 0.0

  def initialize(@x : Float64, @y : Float64, @z : Float64) end
  def initialize(val : Float64) @x = @y = @z = val end
  def initialize() end

  def r() @x end
  def g() @y end
  def b() @z end

  def - : self Vector3.new(-x, -y, -z) end

  def +(right : self) Vector3.new(x + right.x, y + right.y, z + right.z) end
  def -(right : self) Vector3.new(x - right.x, y - right.y, z - right.z) end
  def *(right : self) Vector3.new(x * right.x, y * right.y, z * right.z) end
  def /(right : self) Vector3.new(x / right.x, y / right.y, z / right.z) end

  def +(right : Float64) Vector3.new(x + right, y + right, z + right) end
  def -(right : Float64) Vector3.new(x - right, y - right, z - right) end
  def *(right : Float64) Vector3.new(x * right, y * right, z * right) end
  def /(right : Float64) Vector3.new(x / right, y / right, z / right) end

  def dot(other : self) : Float64
    x * other.x + y * other.y + z * other.z
  end

  def cross(other : self) : self
    Vector3.new(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x,
    )
  end

  def normalize() : self
    length = Math.sqrt(self.dot(self))
    self / length
  end

  def arg_max() : Int32
    return 0 if (x > y && x > z)
    return 1 if (y > x && y > z)
    return 2
  end

  def arg_min() : Int32
    return 0 if (x < y && x < z)
    return 1 if (y < x && y < z)
    return 2
  end

  def cwise_max(other : self) : self
    Vector3.new(
      Math.max(x, other.x),
      Math.max(y, other.y),
      Math.max(z, other.z)
    )
  end

  def cwise_min(other : self) : self
    Vector3.new(
      Math.min(x, other.x),
      Math.min(y, other.y),
      Math.min(z, other.z)
    )
  end

  def [](index : Int32) : Float64
    case index
      when 0 then x
      when 1 then y
      when 2 then z
      else raise "Invalid index into Vector3"
    end
  end

  def []=(index : Int32, value : Float64)
    case index
      when 0 then x = value
      when 1 then y = value
      when 2 then z = value
      else raise "Invalid index into Vector3"
    end
  end

  def to_s(io : IO)
    io << "(%.2f, %.2f, %.2f)" % [x, y, z]
  end
end

struct Float64
  def +(right : Vector3) Vector3.new(self + right.x, self + right.y, self + right.z) end
  def -(right : Vector3) Vector3.new(self - right.x, self - right.y, self - right.z) end
  def *(right : Vector3) Vector3.new(self * right.x, self * right.y, self * right.z) end
  def /(right : Vector3) Vector3.new(self / right.x, self / right.y, self / right.z) end
end

module Random
  def self.in_hemisphere(normal : Vector3) : Vector3
    u = Random.rand(1.0) * 2 - 1
    theta = Random.rand(1.0) * 2 * Math::PI
    r = Math.sqrt(1 - u * u)

    random_ray = Vector3.new(
      r * Math.cos(theta),
      r * Math.sin(theta),
      u)

    return (normal + random_ray).normalize
  end
end
