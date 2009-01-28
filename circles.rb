require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :dot, :last_pos
  include Capture

  def setup
    self.dot = Dot.new
    pos = Position.new
    self.last_pos = pos
    
    frame_rate 15
    smooth
  end
  
  def draw    
    fill 100+rand(40),100+rand(40), 100+rand(80), 5
    rect -1, -1, P.width+1, P.height+1
    
    pos = Position.new last_pos
    
    line pos.x, pos.y, last_pos.x, last_pos.y
    dot.show
    self.last_pos = pos
    
    dot.shift last_pos
    dot.show
  end
  
  include Capture
end

P = MySketch.new :title => "My Sketch", :width => 500, :height => 500
