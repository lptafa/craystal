class Scene
  property msaa = 1
  property objects = [] of Obj

  def intersect(r : Ray, isect : Intersection) : Bool
    hit = false

    objects.each do |object|
      hit = object.intersect(r, isect) || hit
    end

    hit
  end
end
