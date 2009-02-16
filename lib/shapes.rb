class Circle
  def initialize position, radius
    P.ellipse position.x, position.y, radius, radius
  end
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

class Line
  def initialize x,y, length, rotation
    sx = x + length * Math.cos(rotation)  
    sy = y + length * Math.sin(rotation)  

    P.line x,y, sx, sy
    # nope
  end
  
  def self.from_p start,stop
    P.line start.x,start.y,stop.x,stop.y
  end
end
