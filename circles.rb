require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'
require 'pathname'

class MySketch < Processing::App
  load_libraries :control_panel, :pdf
  import "processing.pdf"
  #include PGraphicsPDF
  
  attr_accessor :i

  def setup
    setup_controls
    frame_rate 1
    no_stroke
    smooth
    @opacity = 30
    @thickness = 100
    @red = true
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.slider(:opacity, 0..255)
      c.slider(:thickness, 30..500)
      c.checkbox :red
      c.checkbox :green
      c.checkbox :blue
      c.checkbox :cyan
      c.checkbox :yellow
      c.checkbox :magenta
      c.checkbox :orange
      c.checkbox :black
      #c.checkbox :white
    end
  end
  
  def draw
    begin_record(PDF, "#{Pathname.new(__FILE__).realpath.parent}/pdfs/circles-####.pdf" ) if @record
    
    reset_i
    recurse_circle
    
    end_record if @record
    @record = false
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
    colors = []
    colors << [255,0,0]     if @red
    colors << [0,255,0]     if @green
    colors << [0,0,255]     if @blue
    colors << [0,255,255]   if @cyan
    colors << [255,255,0]   if @yellow
    colors << [255,0,255]   if @magenta
    colors << [255,127,0]   if @orange
    colors << [0,0,0]       if @black
    colors << [255,255,255] if @white
    
    fill_with = colors.shuffle!.first
    fill_with ||= [255,255,255]
    fill *(fill_with.push rand(@opacity))
    #fill *([255,0,0].shuffle!.push rand(100))
  end
  
  def mouse_pressed
    @record = true
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
