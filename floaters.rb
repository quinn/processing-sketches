require 'ruby-processing'

class MySketch < Processing::App
  load_ruby_library "control_panel"
  
  attr_accessor :scaler, :direction, :floaters
  
  def setup
    control_panel do |c|
      c.slider    :alpha,  0.0..1.0
    end
    
    color_mode RGB, 1.0
    frame_rate 30
    fill 0.8
    
    @bgcolors = [0.06, 0.03, 0.18]
    @scaler = 0
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
    if floaters.size < 20
      @floaters << floater = Floater.new
    end
     
    @floaters.each do |f|      
      f.show
    end
    
    fill rand(0xFFFF00FF)
    strokeWeight 3
  end
  
end

class Floater
  attr_accessor :width, :height, :x_offset, :y_offset,
    :x_direction, :y_direction
  
  def initialize
    @width = 50
    @height = 50
    @x_offset = 50
    @y_offset = 50
    @x_direction = 'forward'
    @y_direction = 'forward'
  end
    
  def show
    move 'x', (x_offset > (P.width - 50))
    move 'y', (y_offset > (P.height - 50))
    
    text quadrant, x_offset, y_offset
    params
  end
  
  def move axis, switch
    if switch
      self.send "#{axis}_direction=", 'reverse'
    end
    
    if self.send("#{axis}_offset") < 0
      self.send "#{axis}_direction=", 'forward'
    end
    ,
    if self.send("#{axis}_direction") == 'forward'
      self.send "#{axis}_offset=", (self.send("#{axis}_offset")+rand(20))
    else
      self.send "#{axis}_offset=", (self.send("#{axis}_offset")-rand(20))
    end
  end
  
  def params
    P.quad x_offset+rand(5), y_offset+rand(5),              x_offset+width+rand(5), y_offset+rand(5), 
           x_offset+width+rand(5), y_offset+height+rand(5), x_offset+rand(5), y_offset+height+rand(5)
  end
  
  def quadrant
    if x_offset > (P.width * 2/3)
      x_quadrant = 'right'
    elsif x_offset > (P.width * 1/3)
      x_quadrant = 'center'
    else
      x_quadrant = 'left'
    end
    
    if y_offset > (P.height * 2/3)
      y_quadrant = 'bottom'
    elsif y_offset > (P.height * 1/3)
      y_quadrant = 'center'
    else
      y_quadrant = 'top'
    end
    
    return "#{x_quadrant}-#{y_quadrant}"
  end
end

P = MySketch.new :title => "My Sketch", :width => 800, :height => 900
