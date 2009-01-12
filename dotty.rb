require 'ruby-processing'

class MySketch < Processing::App
  attr_accessor :dot, :last_pos
  def setup
    self.dot = Dot.new
    pos = Position.new
    self.last_pos = pos
    
    frame_rate 15
    smooth
  end
  
  def draw    
    fill 100+rand(40),100+rand(40), 100+rand(80), 10
    rect -1, -1, P.width+1, P.height+1
    
    pos = Position.new last_pos
    
    line pos.x, pos.y, last_pos.x, last_pos.y
    dot.show
    self.last_pos = pos
    
    dot.shift last_pos
    dot.show
  end
end

class Dot
  attr_accessor :x_offset, :y_offset
  
  def initialize
    self.x_offset = 100
    self.y_offset = 100
  end
  
  def shift pos
    self.x_offset = pos.x
    self.y_offset = pos.y
  end
  
  def show
    P.fill 255,255,255
    P.ellipse x_offset, y_offset, 20, 20
    P.fill 0,0,0
    P.ellipse x_offset, y_offset, 3, 3
  end
end

class Position
  attr_accessor :x, :y
  
  def initialize last_pos = nil
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
      self.x = P.width / 2
      self.y = P.height / 2
    end
  end
end

P = MySketch.new :title => "My Sketch", :width => 500, :height => 500
