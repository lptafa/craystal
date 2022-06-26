class BVH < Obj
  property left  : Obj
  property right : Obj

  def initialize(@left, @right, @aabb)
    @color = Vector3.new()
  end

  def self.create(list : Array(Obj))
    if list.size == 1
      return list[0]
    end

    bb = list.reduce AABB.new() do |acc, curr|
      acc.merge(curr.aabb)
    end

    longest = (bb.max - bb.min).arg_max

    list.sort_by! do |object|
      object.aabb.center[longest]
    end

    middle_index = list.size // 2

    left = self.create(list[..middle_index - 1])
    right = self.create(list[middle_index..])

    self.new(left, right, bb)
  end

  def intersect(r : Ray, isect : Intersection)
    tl =  left.aabb.intersect(r, isect)
    tr = right.aabb.intersect(r, isect)
    return false unless tl || tr

    return right.intersect(r, isect) unless tl
    return  left.intersect(r, isect) unless tr

    hit = false
    if tl < tr
      hit = true if left.intersect(r, isect)
      hit = true if right.intersect(r, isect)
    else
      hit = true if right.intersect(r, isect)
      hit = true if left.intersect(r, isect)
    end
    return hit
  end
end
