require 'ruby-processing'

class MySketch < Processing::App
  attr_accessor :scaler, :direction
  
  def setup
    color_mode RGB, 1.0
    frame_rate 30
    fill 0.8
    
    @scaler = 0
    @direction = 'right'
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
    quad(scaler, 5, rand(width), rand(50)+50, mouseX, rand(600)+50, rand(width), rand(50)+50)
  end
end

MySketch.new :title => "My Sketch", :width => 800, :height => 900
