require "option_parser"

require "./vector3"
require "./image"
require "./camera"
require "./object"
require "./parser"

width  = 512
height = 512
model = "amogus.obj"
output = "test.ppm"
msaa = 2

OptionParser.parse do |parser|
  parser.banner = "Yes, I like me some Crystal"

  parser.on("-w WIDTH", "--width WIDTH", "Width"){ |w| width = w.to_i32 }
  parser.on("-h HEIGHT", "--height HEIGHT", "Height"){ |h| height = h.to_i32 }
  parser.on("-r RESOLUTION", "--resolution RESOLUTION", "Square res") do |r|
    height = r.to_i32
    width  = r.to_i32
  end
  parser.on("-i INPUT", "--input INPUT", "Obj file to render"){ |input| model = input }
  parser.on("-o OUTPUT", "--outut OUTPUT", "Output file name"){ |input| output = input }
  parser.on("-a SAMPLES", "--msaa SAMPLES", "Multi sample count"){ |input| msaa = input.to_i32 }
end

def render(scene : Scene, ray : Ray)
  isect = Intersection.new()
  if scene.intersect(ray, isect)
    return isect.normal.as(Vector3) * 0.5 + 0.5
  end

  # Arbitrary background colour
  Vector3.new(0.5, 0.7, 1.0)
end

# ------------------------------------ main ------------------------------------

camera_location = Vector3.new(7)
camera_direction = -camera_location
fov = 30

image = Image.new(width, height)
scene = Scene.new
camera = Camera.new(width, height, camera_location, camera_direction, fov)

parse_obj(model, scene)

rows_done = 0

image.height.times do |y|
  spawn do
    rng = Random.new
    image.width.times do |x|
      total = Vector3.new
      msaa.times do
        du = (x + rng.rand(1.0)) / image.width
        dv = (y + rng.rand(1.0)) / image.height
        ray = camera.get_ray(du, 1 - dv)
        total = total + render(scene, ray)
      end
      image[x, y] = total / msaa
    end
    rows_done += 1
  end
end

while rows_done < image.height
  Fiber.yield
end
Fiber.yield

image.save(output)

