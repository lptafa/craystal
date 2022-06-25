require "./vector3"
require "./camera"

EPSILON = 1e-6

class Intersection
  setter t : Float64 = Float64::MAX
  setter tri : Triangle | Nil = nil
  setter normal : Vector3 | Nil = nil
end

class Scene
  @objects : Array(Triangle) = [] of Triangle

  def intersect(r : Ray, isect : Intersection)
    hit = false

    @objects.each do |object|
      if object.intersect(r, isect)
        hit = true
      end
    end
    hit
  end
end

class Triangle
  @p0 : Vector3
  @p1 : Vector3
  @p2 : Vector3

  @n0 : Vector3
  @n1 : Vector3
  @n2 : Vector3

  @color : Vector3

  def initialize(@p0, @p1, @p2, @n0, @n1, @n2, @color) end

  def intersect(r : Ray, isect : Intersection)
    edge1 = @p1 - @p0
    edge2 = @p2 - @p0

    h = r.@direction.cross(edge2)
    a = edge1.dot(h)
    if a > -EPSILON && a < EPSILON
      return false
    end

    f = 1.0 / a
    s = r.@origin - @p0
    v = f * s.dot(h)

    if v < 0.0 || v > 1.0
      return false
    end

    q = s.cross(edge1)
    w = f * r.@direction.dot(q)

    if w < 0.0 || v + w > 1.0
      return false
    end

    t = f * edge2.dot(q)
    if t < EPSILON || t > isect.@t
      return false
    end

    isect.t = t
    isect.tri = self

    u = 1 - v - w
    isect.normal = Vector3.new(
      @n0.@x * u + @n1.@x * v + @n2.@x * w,
      @n0.@y * u + @n1.@y * v + @n2.@y * w,
      @n0.@z * u + @n1.@z * v + @n2.@z * w,
    )

    return true
  end
end
