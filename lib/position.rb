class Position
  attr_accessor :x, :y, :follow
  
  def initialize last_pos = nil, opts = {}
    if last_pos.is_a? Symbol
      @follow = last_pos
      return
    end
    
    @follow = opts.delete :follow
    
    if last_pos
      if rand(2) == 1
        self.x = last_pos.x + rand(100)*(rand(3)-1)
        self.x = P.width if x > P.width
        self.x = 0 if x < 0
        self.y = last_pos.y
      else
        self.x = last_pos.x
        self.y = last_pos.y + rand(100)*(rand(3)-1)
        self.y = P.height if y > P.height
        self.y = 0 if y < 0
      end
    else
      self.x = rand(P.width)
      self.y = rand(P.height)
    end
  end
  
  def to_vertex
    P.vertex x, y
  end
  
  def x
    return P.width/2 if follow == :center
    return P.mouseX if follow == :mouse
    @x
  end
  
  def y
    return P.height/2 if follow == :center
    return P.mouseY if follow == :mouse
    @y
  end
end
