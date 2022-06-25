struct Vector3
  property x : Float64 = 0.0
  property y : Float64 = 0.0
  property z : Float64 = 0.0

  def initialize(@x : Float64, @y : Float64, @z : Float64) end
  def initialize(val : Float64) x = y = z = val end
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

  def dot(other : self)
    x * other.x + y * other.y + z * other.z
  end

  def cross(other : self)
    Vector3.new(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x,
    )
  end

  def normalize()
    length = Math.sqrt(self.dot(self))
    self / length
  end

  def [](index : Int32)
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
end

struct Float64
  def +(right : Vector3) Vector3.new(self + right.x, self + right.y, self + right.z) end
  def -(right : Vector3) Vector3.new(self - right.x, self - right.y, self - right.z) end
  def *(right : Vector3) Vector3.new(self * right.x, self * right.y, self * right.z) end
  def /(right : Vector3) Vector3.new(self / right.x, self / right.y, self / right.z) end
end
