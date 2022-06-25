struct Vector3
  @x : Float64 = 0.0
  @y : Float64 = 0.0
  @z : Float64 = 0.0

  def initialize(@x : Float64,
                 @y : Float64,
                 @z : Float64)
  end

  def initialize(val : Float64)
    @x = val
    @y = val
    @z = val
  end

  def initialize()
  end

  def - : self
    Vector3.new(-@x, -@y, -@z)
  end

  def +(right : self) Vector3.new(@x + right.@x, @y + right.@y, @z + right.@z) end
  def -(right : self) Vector3.new(@x - right.@x, @y - right.@y, @z - right.@z) end
  def *(right : self) Vector3.new(@x * right.@x, @y * right.@y, @z * right.@z) end
  def /(right : self) Vector3.new(@x / right.@x, @y / right.@y, @z / right.@z) end

  def +(right : Float64) Vector3.new(@x + right, @y + right, @z + right) end
  def -(right : Float64) Vector3.new(@x - right, @y - right, @z - right) end
  def *(right : Float64) Vector3.new(@x * right, @y * right, @z * right) end
  def /(right : Float64) Vector3.new(@x / right, @y / right, @z / right) end

  def dot(other : self)
    @x * other.@x + @y * other.@y + @z * other.@z
  end

  def cross(other : self)
    Vector3.new(
      @y * other.@z - @z * other.@y,
      @z * other.@x - @x * other.@z,
      @x * other.@y - @y * other.@x,
    )
  end

  def normalize()
    length = Math.sqrt(self.dot(self))
    self / length
  end
end
