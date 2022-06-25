require "./vector3"

class Image
  property width : Int32
  property height : Int32
  property pixels : Array(Vector3)

  def initialize(@width, @height)
    @pixels = Array.new(width * height, Vector3.new())
  end

  def save(filename : String)
    File.open(filename, "w") do |file|
      file.write("P3 #{width} #{height} 255\n".to_slice)
      pixels.each do |pixel|
        r = (pixel.r * 255).to_i32
        g = (pixel.g * 255).to_i32
        b = (pixel.b * 255).to_i32
        file.write("#{r} #{g} #{b} ".to_slice)
      end
    end
  end

  def [](x : Int32, y : Int32) : Vector3
    pixels[x + y * width]
  end

  def []=(x : Int32, y : Int32, value : Vector3)
    pixels[x + y * width] = value
  end
end
