require 'ruby-processing'
#require 'lib/position'
#require 'lib/dot'
require 'lib/shapes'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  load_libraries :gemmings
  load_gem 'quinn-ruby-svg', :load_as => 'ruby-svg'
  
  include SVG::Processing
  
  def setup
    setup_controls
    frame_rate 40

    @previous_points = 0
    smooth
    no_stroke
    
    fill 0
    text_font create_font("Arial", 10)      
    @offset = 0

    @timeout = 5
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    fill 255,255,255, 5
    no_stroke
    rect 0,0, width,height
    stroke 255,0,0
    
    @timeout -= 1
    return if @timeout != 0
    @timeout = 5
    
  	innerRadius = 50

  	origx = rand(width)
  	origy = rand(height)
  	
    points = 3 + rand(5)
    angleChangePerPt = TWO_PI / points

  	start_angle = radians rand(60)
    @offset = 20+rand(200)
    
	  points.times do |i|
	    angle = start_angle + angleChangePerPt*i
      x = origx + innerRadius
			y = origy + innerRadius
			

      stroke 255,0,0
      no_fill
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
      
      stroke 255,0,0
      fill   255,0,0
			bezier x,y, x+cos(off1)*(l1),y+sin(off1)*(l1), end_x-cos(off2)*l2, end_y-sin(off2)*l2, end_x, end_y
      end
		
    if creating_output
      save_image_action
      save_svg_file
      @creating_output = false
    end
  end
  
  def hypott startx,starty,endx,endy
    theight = (starty - endy)
    twidth  = (startx - endx)
    length = Math.sqrt(twidth**2 + theight**2)
    length
  end
  
  def angle_off startx,starty,endx,endy
    theight = (starty - endy)
    twidth  = (startx - endx)
    angle = atan(twidth.to_f/theight)
    # i have no idea what these next 3 lines do
    # i just wrote them
    offset = (twidth > 0) ? radians(180) : 0
    offset -= ((theight > 0) and !(twidth > 0)) ? radians(180) : 0
    offset += (!(theight > 0) and (twidth > 0)) ? radians(180) : 0
    
    
    
    offset_angle = offset + radians(90) - angle
  end
  
  def quadrant startx,starty,endx,endy
    
  end
  
  def radians deg
    deg.to_f*(PI/180.0)
  end
  
  def degrees radian
    radian/(PI/180.0)
  end
  
  def perp radian
    radian.to_f - radians(90.0)
  end
  
  def output_svg
    # unless ready_for_output
    #   puts "\033[1mwarning:\033[0m not ready for output"
    #   return
    # end
    # @saving
    # save_image_action
    # save_svg_file
    # puts "file saved"
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
