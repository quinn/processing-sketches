require 'ruby-processing'
require 'lib/position'
#require 'lib/dot'
require 'lib/shapes'
require 'lib/trig'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  load_libraries :gemmings
  load_gem 'quinn-ruby-svg', :load_as => 'ruby-svg'
  
  include SVG::Processing
  include Trig
  
  def setup
    setup_controls
    frame_rate 40

    @previous_points = 0
    smooth
    no_stroke
    
    fill 0
    text_font create_font("Arial", 10)      
    @offset = 0
    @t = 15
    @timeout = @t
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    fill 255,255,255, 1
    no_stroke
    rect 0,0, width,height

    color = [200+rand(55), rand(50), 30]
    no_stroke
    fill_brights
    
    @timeout -= 1
    return if @timeout != 0
    @timeout = @t
    
  	innerRadius = 50
    
    endp = Position.new
  	origx = endp.x
  	origy = endp.y
  	
    points = 3 + rand(5)
    angleChangePerPt = TWO_PI / points

  	start_angle = radians rand(60)
    @offset = 20+rand(200)
    
    startp = Position.new
    startp.x = rand(width)
    startp.y = rand(100) + height
  	connect startp, endp

	  points.times do |i|
	    angle = start_angle + angleChangePerPt*i
      x = origx + innerRadius
			y = origy + innerRadius
			
      end_x = x = origx
			end_y = y = origy
      
      c1x = origx - @offset*cos(angle)
      c1y = origy - @offset*sin(angle)
      c2x = origx - @offset*cos(angle)
      c2y = origy - @offset*sin(angle)
      
      l1   = hypott(x,y, c1x,c1y)           #+ mouseY
      l2   = hypott(c2x,c2y, end_x,end_y)   #- mouseY
      off1 = (angle_off x,y, c1x,c1y)         - radians(@offset)
      off2 = (angle_off c2x,c2y, end_x,end_y) + radians(@offset)
      
			bezier x,y, x+cos(off1)*(l1),y+sin(off1)*(l1), end_x-cos(off2)*l2, end_y-sin(off2)*l2, end_x, end_y
    end

    if creating_output
      save_image_action
      save_svg_file
      @creating_output = false
    end
  end
    
  def quadrant startx,starty,endx,endy
    
  end
    
  def fill_brights
    colors = []
    colors << [255,0,0]      # red
    #colors << [0,255,0]      # green
    colors << [0,0,255]      # blue
    #colors << [0,255,255]    # cyan
    colors << [255,255,0]    # yellow
    #colors << [255,0,255]    # magenta
    colors << [220,0,200]    # purple
    colors << [255,127,0]    # orange
    #colors << [0,0,0]        # black
    colors << [255,255,255]  # white
    
    fill_with   = colors.shuffle!.first
    fill_with ||= [255,255,255]
    fill *fill_with
  end
  
  def output_svg
    @creating_output = true
  end
  
  def reset
    # @ready_for_output = false
    reset_svg
    background 200
  end
  attr_accessor :creating_output

  include Capture
end

P = MySketch.new :title => "Flowers", :width => 700, :height => 700#, :full_screen => true
