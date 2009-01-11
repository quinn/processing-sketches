require 'ruby-processing'

class MySketch < Processing::App
  load_ruby_library "control_panel"
  
  attr_accessor :scaler, :direction
  
  def setup
    control_panel do |c|
      c.slider    :alpha,  0.0..1.0
    end
    
    color_mode RGB, 1.0
    frame_rate 30
    fill 0.8
    
    @background = [0.06, 0.03, 0.18]
    @scaler = 0
    @direction = 'right'
    @alpha = 1.0
  end
  
  def background=(*args)
    @background = args.flatten
  end
  
  def draw_background
    @background[3] = @alpha
    fill *@background if @background[0]
    rect 0, 0, width, height
  end
  
  def draw
    
    if scaler > width
      @direction = 'left'
    end
    
    if scaler < 0
      @direction = 'right'
    end
    
    if direction == 'right'
      @scaler += 5
    else
      @scaler -= 5
    end
    
    fill rand(0xFFFF00FF)
    strokeWeight rand(10)
    quad(mouseX, mouseY, rand(width), rand(50)+50, 5, 5, rand(width), rand(50)+50)
    draw_background
  end
end

MySketch.new :title => "My Sketch", :width => 800, :height => 900
