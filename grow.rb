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
    fill 200,200, 200, 50
    rect 0,0, P.width, P.height
    
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
        self.x = rand(P.width)
        self.y = last_pos.y
      else
        self.x = last_pos.x
        self.y = rand(P.height)
      end
    else
      self.x = rand(P.width)
      self.y = rand(P.height)
    end
  end
end

P = MySketch.new :title => "My Sketch", :width => 800, :height => 760
