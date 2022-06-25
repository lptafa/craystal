require "option_parser"

require "./vector3"
require "./image"
require "./camera"
require "./object"
require "./parser"

width  = 512
height = 512
model = "amogus.obj"
msaa   = 2

OptionParser.parse do |parser|
  parser.banner = "I have crystals in my butt"

  parser.on("-w WIDTH", "--width WIDTH", "Width"){ |w| width = w.to_i32 }
  parser.on("-h HEIGHT", "--height HEIGHT", "Height"){ |h| height = h.to_i32 }
  parser.on("-r RESOLUTION", "--resolution RESOLUTION", "Square res") do |r|
    height = r.to_i32
    width  = r.to_i32
  end
  parser.on("-i INPUT", "--input INPUT", "Obj file to render"){ |input| model = input }
  parser.on("-a SAMPLES", "--msaa SAMPLES", "Multi sample count"){ |input| msaa = input.to_i32 }
end

BG = Vector3.new(0.5, 0.7, 1.0)

def render(scene : Scene, ray : Ray)
  isect = Intersection.new()
  if scene.intersect(ray, isect)
    return isect.@normal.as(Vector3) * 0.5 + 0.5
  end

  Vector3.new(1, 1, 1)
end

image = Image.new(width, height)

scene = Scene.new()
# parse_obj(model, scene)

camera = Camera.new(
  width,
  height,
  Vector3.new(7, 7, 7),
  Vector3.new(-1, -1, -1),
  180.0
)

counter = 0
image.@height.times do |y|
  spawn same_thread: false do
    randomizer = Random.new
    image.@width.times do |x|
      total = Vector3.new

      msaa.times do
        du = (x + randomizer.rand(1.0)) / image.@width
        dv = (y + randomizer.rand(1.0)) / image.@height
        ray = camera.get_ray(du, 1 - dv)
        total = total + render(scene, ray)
      end
      image.set(x, y, total / msaa)
    end
    counter += 1
  end
end

while counter < image.@height
  sleep 0.1
end
Fiber.yield

image.save("test.ppm")
