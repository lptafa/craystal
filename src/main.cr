require "yaml"
require "option_parser"

require "./vector3"
require "./image"
require "./camera"
require "./scene"
require "./object"
require "./renderer"
require "./obj_parser"
require "./yaml_utils"
require "./aabb"
require "./bvh"

width  = 512
height = 512

camera_location = Vector3.new(300, -300, -300)
camera_direction = -camera_location
fov = 90.0

model = "amogus.obj"
output = "test.ppm"
msaa = 1
bvh_enabled = true
debug_enabled = false

OptionParser.parse do |parser|
  parser.banner = "Yes, I like me some Crystal"

  parser.on("-h", "--help", "Show this help message") do
    puts parser
    exit(0)
  end

  # FIXME: There has to be a better place to put this logic into
  parser.on("-s SCENE", "--scene SCENE", "Use Scene YAML file") do |input|
    yaml = File.open(input) { |file| YAML.parse(file) }

    yaml.on "obj" { |val| model = val.as_s }
    yaml.on "bvh" { |val| bvh_enabled = val.as_bool }
    yaml.on "debug" { |val| debug = val.as_bool }
    yaml.on "msaa" { |val| msaa = val.as_i }
    yaml.on "output" { |val| output = val.as_s }

    yaml.on("resolution") do |val|
      width = height = val.as_i
    end

    yaml.on("camera") do |camera|
      camera.on("position") { |val| camera_location = val.to_vec }
      camera.on("lookat") { |val| camera_direction = val.to_vec - camera_location }
      camera.on("direction") { |val| camera_direction = val.to_vec }
      camera.on("fov") { |val| fov = val.to_f }
    end
  end

  parser.on("-w WIDTH", "--width WIDTH", "Width"){ |w| width = w.to_i32 }
  parser.on("-h HEIGHT", "--height HEIGHT", "Height"){ |h| height = h.to_i32 }
  parser.on("-r RES", "--resolution RES", "Square res") do |r|
    height = r.to_i32
    width  = r.to_i32
  end
  parser.on("-i INPUT", "--input INPUT", "Obj file to render"){ |input| model = input }
  parser.on("-o OUTPUT", "--outut OUTPUT", "Output file name"){ |input| output = input }
  parser.on("-a SAMPLES", "--msaa SAMPLES", "Multi sample count"){ |input| msaa = input.to_i32 }
  parser.on("-n", "--no-bvh", "Disable bounding volume hierarchy"){ |_| bvh_enabled = false }
  parser.on("-d", "--debug", "Render using the debug renderer"){ |_| debug_enabled = true }
end

# ------------------------------------ main ------------------------------------

scene = Scene.new
scene.msaa = msaa

puts "--------------------------------------------------------------"
puts "- Camera: (FOV: #{fov})"
puts "   - location: #{camera_location}"
puts "   - direction: #{camera_direction}"
puts "- Model: #{model}"
puts "- Resolution: #{width} x #{height}, MSAA: #{msaa}"
puts "- Output: #{output}"
puts "- BVH: #{bvh_enabled}, Debug: #{debug_enabled}"
puts "--------------------------------------------------------------"

camera = Camera.new(width, height, camera_location, camera_direction, fov)
parse_obj(model, scene, Vector3.new(1))

if bvh_enabled
  bvh = BVH.create(scene.objects)
  scene.objects = [bvh]
end

renderer = AORenderer.new
if debug_enabled
  renderer = DebugRenderer.new
end

time = Time.utc

image = renderer.render_image(scene, camera)

image.save(output)

puts "Rendering took #{Time.utc - time}"
