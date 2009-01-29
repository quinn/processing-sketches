require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  
  def setup
    setup_controls
    frame_rate 20
    no_stroke
    smooth
    @opacity = 30
    @thickness = 100
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.slider(:opacity, 0..255)
      c.slider(:thickness, 30..500)
    end
  end
  
  def draw
    background 255,255,255
    reset_i
    recurse_circle
  end
  
  def recurse_circle
    recurse_circle if drawing_circle
  end
  
  def drawing_circle
    @i -= rand(@thickness)/10.0
    return if @i < 0
    fill_brights
    Circle.new Position.new(:center), @i    
  end
  
  def reset_i
    @i = 800
  end
  include Capture
  
  def t55
    return 0 if rand(2) == 0
    255
  end
  
  def fill_brights
    fill *([
      [255,0,0]     ,          # red
      #[0,255,0]     ,         # green
      #[0,0,255]     ,          # blue
      [0,255,255]   ,          # cyan
      #[255,255,0]   ,         # yellow
      [255,0,255]   ,          # magenta
      [255,127,0]   ,          # orange
      [0,0,0]       ,          # black
      [255,255,255] ,          # white
    ].shuffle!.first.push rand(@opacity))
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
P = MySketch.new :title => "Circles", :width => 500, :height => 500#, :full_screen => true
