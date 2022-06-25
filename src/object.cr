require "./vector3"
require "./camera"

EPSILON = 1e-6

class Intersection
  property t = Float64::MAX
  property tri    : Triangle | Nil = nil
  property normal : Vector3  | Nil = nil
end

class Scene
  property objects = [] of Triangle

  def intersect(r : Ray, isect : Intersection) : Bool
    hit = false

    objects.each do |object|
      if object.intersect(r, isect)
        hit = true
      end
    end
    hit
  end
end

class Triangle
  property p0 : Vector3
  property p1 : Vector3
  property p2 : Vector3

  property n0 : Vector3
  property n1 : Vector3
  property n2 : Vector3

  property color : Vector3

  def initialize(@p0, @p1, @p2, @n0, @n1, @n2, @color) end

  def intersect(r : Ray, isect : Intersection) : Bool
    edge1 = p1 - p0
    edge2 = p2 - p0

    h = r.direction.cross(edge2)
    a = edge1.dot(h)
    if -EPSILON < a < EPSILON
      return false
    end

    f = 1.0 / a
    s = r.origin - p0
    v = f * s.dot(h)

    if v < 0.0 || v > 1.0
      return false
    end

    q = s.cross(edge1)
    w = f * r.direction.dot(q)

    if w < 0.0 || v + w > 1.0
      return false
    end

    t = f * edge2.dot(q)
    if t < EPSILON || t > isect.t
      return false
    end

    isect.t = t
    isect.tri = self

    u = 1 - v - w
    isect.normal = Vector3.new(
      n0.x * u + n1.x * v + n2.x * w,
      n0.y * u + n1.y * v + n2.y * w,
      n0.z * u + n1.z * v + n2.z * w,
    )

    return true
  end
end
