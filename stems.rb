require 'ruby-processing'
require 'lib/position'
require 'lib/trig'
require 'lib/shapes'
#require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  load_libraries :gemmings
  load_gem 'quinn-ruby-svg', :load_as => 'ruby-svg'
  
  include SVG::Processing
  include Trig
  attr_accessor :a,:z
  def setup
    setup_controls
    frame_rate 0.3
    
    smooth
    # @a = Position.new
    # @z = Position.new
    
    fill 0
    stroke_weight 0.2
    text_font create_font("Arial", 10)      
    @i = 0.0
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
      c.button :draw
    end
  end
  
  def draw
    reset

    start_point = Position.new
    end_point   = Position.new
    axis        = Position.new
    
    
    Circle.new end_point, 6
    Circle.new axis, 6
    
    points = 6

    angle = angle_off    axis.x, axis.y, end_point.x, end_point.y
    innerRadius = hypott axis.x, axis.y, end_point.x, end_point.y
    
    angleChangePerPt = angle / points
    
    
    stroke 255, 0, 0
    Line.new axis.x, axis.y, innerRadius, angle
    stroke 0
    
    points.times do |i|
			# draw polygon
			angle = angleChangePerPt * i
			x = axis.x + innerRadius * cos(angle)
			y = axis.y + innerRadius * sin(angle)
      
      line axis.x, axis.y, x, y
      
      stroke 0
      fill 0,0,0
  	end
  	
    if @creating_output
      @creating_output = false
      save_image_action
    end
  end
    
  def o x = 500
    (rand(x)-(x/2))
  end
    
  def output_svg
    @creating_output = true
  end
  
  def reset
    @ready_for_output = false
    reset_svg
    background 200
  end
  attr_accessor :ready_for_output

  include Capture
end

P = MySketch.new :title => "Stems", :width => 700, :height => 700#, :full_screen => true
