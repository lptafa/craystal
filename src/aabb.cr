struct AABB
  property min : Vector3
  property max : Vector3

  def initialize(@min, @max)
  end

  def initialize(point : Vector3)
    @min = @max = point
  end

  def initialize
    @min = Vector3.new(Float64::MAX)
    @max = Vector3.new(Float64::MIN)
  end

  def merge(other : self) : self
    AABB.new(
      @min.cwise_min(other.min),
      @max.cwise_max(other.max))
  end

  def merge(point : Vector3) : self
    AABB.new(
      @min.cwise_min(point),
      @max.cwise_max(point))
  end

  def center : Vector3
    (@min + @max) / 2
  end

  def intersect(r : Ray, isect : Intersection)
    t_min = Float64::MIN
    t_max = Float64::MAX
    {% for comp in %w(x y z) %}
      unless r.direction.{{comp.id}} == 0
        t0 = (@min.{{comp.id}} - r.origin.{{comp.id}}) / r.direction.{{comp.id}}
        t1 = (@max.{{comp.id}} - r.origin.{{comp.id}}) / r.direction.{{comp.id}}

        if t0 > t1
          t0, t1 = t1, t0
        end

        if t0 > t_max || t1 < t_min
          return nil
        end

        t_min = t0 if t0 > t_min
        t_max = t1 if t1 < t_max
      end
    {% end %}

    if t_max < EPSILON || t_min > isect.t
      return nil
    end

    return t_min
  end
end
