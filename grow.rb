require 'ruby-processing'

class MySketch < Processing::App
  load_ruby_library "control_panel"
  
  attr_accessor :scaler, :direction, :floaters
  
  def setup
    control_panel do |c|
      c.slider    :alpha,  0.0..1.0
    end
    
    color_mode RGB, 1.0
    frame_rate 300
    fill 0.8
    
    @bgcolors = [0.06, 0.03, 0.18]
    @scaler = 0
    @direction = 'right'
    @alpha = 1.0
    @floaters = []
  end
  
  def bgcolors=(*args)
    @bgcolors = args.flatten
  end
  
  def draw_background
    @bgcolors[3] = @alpha
    background *@bgcolors if @bgcolors[0]
  end
  
  def draw
    draw_background
    if floaters.size < 50
      @floaters << floater = Floater.new
    end
     
    @floaters.each do |f|
      f.x_offset += 5
      f.y_offset += 10
      f.show
    end
    
    fill rand(0xFFFF00FF)
    strokeWeight 3
  end
  
end

class Floater
  attr_accessor :width, :height, :x_offset, :y_offset
  def initialize
    @width = 50
    @height = 50
    @x_offset = 50
    @y_offset = 50
  end
  
  def show
    params
  end
  
  def params
    P.quad x_offset+rand(5), y_offset+rand(5),              x_offset+width+rand(5), y_offset+rand(5), 
           x_offset+width+rand(5), y_offset+height+rand(5), x_offset+rand(5), y_offset+height+rand(5)
  end
end

P = MySketch.new :title => "My Sketch", :width => 800, :height => 900
