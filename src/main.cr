require "option_parser"

require "./vector3"
require "./image"
require "./camera"
require "./scene"
require "./object"
require "./renderer"
require "./parser"
require "./aabb"
require "./bvh"

width  = 1024
height = 1024
model = "amogus.obj"
output = "test.ppm"
msaa = 1
bvh_enabled = true
debug_enabled = false

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
  parser.on("-n", "--no-bvh", "Disable bounding volume hierarchy optimizations"){ |_| bvh_enabled = false }
  parser.on("-d", "--debug", "Render using the debug renderer"){ |_| debug_enabled = false }
end


renderer = AORenderer.new
if debug_enabled
  renderer = DebugRenderer.new
end
# ------------------------------------ main ------------------------------------

camera_location = Vector3.new(300, -300, -300)
camera_direction = -camera_location
fov = 90

scene = Scene.new
scene.msaa = msaa

camera = Camera.new(width, height, camera_location, camera_direction, fov)

parse_obj(model, scene, Vector3.new(1))

if bvh_enabled
  bvh = BVH.create(scene.objects)
  scene.objects = [bvh]
end

time = Time.utc

image = renderer.render_image(scene, camera)

image.save(output)

puts "Rendering took #{Time.utc - time}"
