require "./vector3"

class Camera
  property width  : Int32
  property height : Int32

  property origin     : Vector3
  property horizontal : Vector3
  property vertical   : Vector3
  property corner     : Vector3

  def initialize(@width : Int32, @height : Int32, @origin, direction : Vector3, fov : Float64)
    aspect_ratio = width / height

    theta = fov * Math::PI / 180
    viewport_height =  2 * Math.tan(theta / 2.0)
    viewport_width = aspect_ratio * viewport_height

    up = Vector3.new(0, 1, 0)

    w = -direction.normalize()
    u = up.cross(w).normalize()
    v = w.cross(u)

    @horizontal = u * -viewport_width
    @vertical = v * viewport_height
    @corner = origin - horizontal / 2 - vertical / 2 - w
  end

  def get_ray(du : Float64, dv : Float64) : Ray
    Ray.new(
      origin,
      (corner + horizontal * du + vertical * dv - origin).normalize()
    )
  end
end

struct Ray
  property origin : Vector3
  property direction : Vector3

  def initialize(@origin, @direction) end
  def at(t : Float64) origin + direction * t end
end
