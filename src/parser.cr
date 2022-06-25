require "./object"

def parse_obj(filename : String, scene : Scene)
  vertices = [] of Vector3
  normals = [] of Vector3

  File.read_lines(filename).each do |line|
    if line.starts_with?("v ")
      values = line.split
      vertices << Vector3.new(values[1].to_f, values[2].to_f, values[3].to_f)

    elsif line.starts_with?("vn ")
      values = line.split
      normals << Vector3.new(values[1].to_f, values[2].to_f, values[3].to_f)

    elsif line.starts_with?("f ")
      values = line.split.skip(1).map do |item|
        item.split("/").map { |x| x.to_i32 }
      end
      scene.objects << Triangle.new(
        vertices[values[0][0] - 1],
        vertices[values[1][0] - 1],
        vertices[values[2][0] - 1],

        normals[values[0][2] - 1],
        normals[values[1][2] - 1],
        normals[values[2][2] - 1],
        Vector3.new(1.0, 0.0, 1.0)
      )
    end
  end
end
