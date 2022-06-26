abstract class Renderer
  def render_image(scene : Scene, camera : Camera) : Image
    image = Image.new(camera.width, camera.height)

    channel = Channel(Bool).new
    image.height.times do |y|
      spawn do
        rng = Random.new
        image.width.times do |x|
          total = Vector3.new
          if scene.msaa > 1
            scene.msaa.times do
              du = (x + rng.rand(1.0)) / image.width
              dv = (y + rng.rand(1.0)) / image.height
              ray = camera.get_ray(du, 1 - dv)
              total = total + render_ray(scene, ray)
            end
            total = total / scene.msaa
          elsif ray = camera.get_ray(x / image.width, 1 - y / image.height)
            total = render_ray(scene, ray)
          end
          image[x, y] = total
        end
        channel.send(true)
      end
    end
    image.height.times do |i|
      channel.receive
    end
    image
  end

  abstract def render_ray(scene : Scene, ray : Ray) : Vector3
end

class DebugRenderer < Renderer
  def render_ray(scene : Scene, ray : Ray) : Vector3
    isect = Intersection.new
    if scene.intersect(ray, isect)
      return isect.normal.as(Vector3) * 0.5 + 0.5
    end

    # Arbitrary background colour
    Vector3.new(0.5, 0.7, 1.0)
  end
end

class AORenderer < Renderer
  def render_ray(scene : Scene, ray : Ray) : Vector3
    isect = Intersection.new
    unless scene.intersect(ray, isect)
      return Vector3.new(0)
    end

    new_ray = Ray.new(ray.at(isect.t), random_in_hemisphere(isect.normal.as Vector3))

    unless scene.intersect(new_ray, Intersection.new())
      return Vector3.new(1)
    end

    Vector3.new(0)
  end

  def random_in_hemisphere(normal : Vector3) : Vector3
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
