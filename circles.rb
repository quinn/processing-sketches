require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  
  def setup
    @i = 2400
    #frame_rate 300
    smooth
    background 255,255,255
  end
  
  def draw
    noStroke
    #fill t55,t55,t55
    fill_brights
    @i -= rand(50)/10.0
    return if @i < 0
    Circle.new Position.new(:center), @i
    
  end
  
  include Capture
  
  def t55
    return 0 if rand(2) == 0
    255
  end
  
  def fill_brights
    fill *([
      [255,0,0]   ,          # red
      #[0,255,0]   ,         # green
      [0,0,255]   ,          # blue
      [0,255,255] ,          # cyan
      #[255,255,0] ,         # yellow
      [255,0,255] ,          # magenta
      [255,127,0] ,          # orange
    ].shuffle!.first.push rand(200))
    #fill *([255,0,0].shuffle!.push rand(100))
    
  end
end

class Circle
  def initialize position, radius
    P.ellipse position.x, position.y, radius, radius
  end
end

class Color
  
  
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end
P = MySketch.new :title => "Circles", :width => 500, :height => 500, :full_screen => true
