require 'ruby-processing'

class MySketch < Processing::App
  load_ruby_library "control_panel"
    
  attr_accessor :scaler, :direction, :floaters
  
  def setup
    control_panel do |c|
      c.slider    :alpha,  0.0..1.0
    end
    
    # hint(ENABLE_NATIVE_FONTS)
    # f = create_font("Monospaced", 66)
    # text_font f, 40.0
    
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
    
    (0...(floaters.length)).each do |ia|
      fa = floaters[ia]
      fa.reversing = fa.reversing - 1 if fa.reversing > 0
      
      ((ia+1)...(floaters.length)).each do |ib|
        fb = floaters[ib]
        
        if fa.quadrant == fb.quadrant
          if (fa.x_offset > fb.x_offset) and (fa.x_offset < (fb.x_offset + 50))
            fb.reverse_x if fb.reversing == 0
            fa.reverse_x if fa.reversing == 0
            
            fa.reversing = 100
          end

          if (fa.y_offset > fb.y_offset) and (fa.y_offset < (fb.y_offset + 50))
            fb.reverse_y if fb.reversing == 0
            fa.reverse_y if fa.reversing == 0

            fa.reversing = 100
          end
        end
      end
      fa.show
    end
        
    strokeWeight 3
  end
  
end

class Floater
  attr_accessor :width, :height, :x_offset, :y_offset,
    :x_direction, :y_direction, :fill_color, :reversing
  
  def initialize
    @width = 50
    @height = 50
    @x_offset = rand 500
    @y_offset = rand 500
    @x_direction = 'forward'
    @y_direction = 'forward'
    @fill_color = rand(0xFFFF00FF)
    @reversing = 0
  end
    
  def show
    P.fill fill_color
    
    move 'x', (x_offset > (P.width - 50))
    move 'y', (y_offset > (P.height - 50))
    
    params
  end
  
  def move axis, switch
    if switch
      self.send "#{axis}_direction=", 'reverse'
    end
    
    if self.send("#{axis}_offset") < 0
      self.send "#{axis}_direction=", 'forward'
    end
    
    if self.send("#{axis}_direction") == 'forward'
      self.send "#{axis}_offset=", (self.send("#{axis}_offset")+2)
    else
      self.send "#{axis}_offset=", (self.send("#{axis}_offset")-2)
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
  
  def reverse_x
    @x_direction = (x_direction == 'forward') ? 'reverse' : 'forward'
  end
  
  def reverse_y
    @y_direction = (y_direction == 'forward') ? 'reverse' : 'forward'
  end
  
  def reversing
    0
  end
end

P = MySketch.new :title => "My Sketch", :width => 800, :height => 760
