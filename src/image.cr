require "./vector3"

class Image
  @width : Int32
  @height : Int32
  @pixels : Array(Vector3)

  def initialize(@width : Int32, @height : Int32)
    @pixels = Array.new(@width * @height, Vector3.new())
  end

  def save(filename : String)
    File.open(filename, "w") do |file|
      file.write("P3 #{@width} #{@height} 255 ".to_slice)
      @pixels.each do |pixel|
        r = (pixel.@x * 255).to_i32
        g = (pixel.@y * 255).to_i32
        b = (pixel.@z * 255).to_i32
        file.write("#{r} #{g} #{b} ".to_slice)
      end
    end
  end

  def get(x : Int32, y : Int32)
    @pixels[x + y * @width]
  end

  def set(x : Int32, y : Int32, value : Vector3)
    @pixels[x + y * @width] = value
  end
end
