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
  
  def setup
    setup_controls
    frame_rate 0.5
    
    smooth
    #no_stroke
    fill 0
    text_font create_font("Arial", 10)
    @i = 0.0
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    reset
    
    p1 = Position.new
    p2 = Position.new
    p3 = Position.new
    
    p2.x = p1.x
    d = (p1.y-p2.y).abs
    p3.y = if p1.y > p2.y
      d/2 + p2.y
    else
      d/2 + p1.y
    end
    
    Circle.new p1, 7
    Circle.new p2, 7
    fill 255, 0, 0
    Circle.new p3, 7
    fill 0
    
    points = 6

    angle = angle_off    p3.x, p3.y, p1.x, p1.y
    innerRadius = hypott p3.x, p3.y, p1.x, p1.y
    
    angleChangePerPt = angle / points
    
    
    stroke 255, 0, 0
    Line.new p3.x, p3.y, innerRadius, angle
    stroke 0
    
    points.times do |i|
			# draw polygon
			angle = angleChangePerPt * i
			x = p3.x + innerRadius * cos(angle)
			y = p3.y + innerRadius * sin(angle)
      
      line p3.x, p3.y, x, y
      
      stroke 0
      fill 0,0,0
  	end
    
    @ready_for_output = true
  end
  
  def do_line xoff,yoff
		line xoff, yoff, 300, yoff
  end
  
  def radians deg
    deg.to_f*(PI/180)
  end
  
  def perp radian
    radian - radians(90)
  end
  
  def output_svg
    unless ready_for_output
      puts "\033[1mwarning:\033[0m not ready for output"
      return
    end
    
    save_svg_file
    puts "file saved"
  end
  
  def reset
    @ready_for_output = false
    reset_svg
    background 200
  end
  attr_accessor :ready_for_output

  include Capture
end

P = MySketch.new :title => "MathTest", :width => 700, :height => 700#, :full_screen => true
