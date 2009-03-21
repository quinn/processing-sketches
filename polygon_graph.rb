require 'ruby-processing'
#require 'lib/position'
#require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  load_libraries :gemmings
  load_gem 'quinn-ruby-svg', :load_as => 'ruby-svg'
  
  include SVG::Processing
  
  def setup
    setup_controls
    frame_rate 18
    @r = 0.0
    @previous_points = 0
    smooth
    no_stroke
    
    fill 0
    text_font create_font("Arial", 10)
    @offset = 0
    
    # http://api.nytimes.com/svc/search/v1/article?query=japan%20publication_year:[1981]%20publication_month:[2]&fields=+&facets=org_facet&&api-key=7ea86ecc92866e9cf37c5f16cd205356:2:57988907
    # http://api.nytimes.com/svc/search/v1/article?query=japan%20publication_year:[1981]%20publication_month:[09]&fields=+&facets=org_facet&api-key=7ea86ecc92866e9cf37c5f16cd205356:2:57988907
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    reset
    percent = mouseX / height.to_f
    points = (3+ percent*14).to_i

    angleChangePerPt = TWO_PI / points
  	innerRadius = 200
  	origx = width/2
  	origy = height/2
  	
  	unless @previous_points == points
  	  @end_x = []
  	  @end_y = []
  	  points.times do |i|
			end
	  end
  	@previous_points = points
  	
  	angle = radians 30
  	begin_shape
  	points.times do |i|
			# draw polygon
			angle = angleChangePerPt * i
			x = origx + innerRadius * cos(angle)
			y = origy + innerRadius * sin(angle)
      
			no_stroke
      fill 0,0,0
			vertex x,y
  	end
	  end_shape
    
    
  	angle = radians 30
	  points.times do |i|
			angle = angleChangePerPt * i
      x = origx + innerRadius * cos(angle)
			y = origy + innerRadius * sin(angle)
			

      stroke 255,0,0
      no_fill
      num = 3
      num -= 1 if points/num == points.to_f/num
      end_point = num + i
      if end_point > points
        end_point = end_point - points
      end
			angle = angleChangePerPt * end_point
      end_x = origx + innerRadius * cos(angle)
			end_y = origy + innerRadius * sin(angle)
      @offset = 200*sin(@r)
      
      c1x = origx - @offset*cos(angle)    #   + (innerRadius - @offset)         
      c1y = origy - @offset*sin(angle)    #   + (innerRadius - @offset)         
      c2x = origx - @offset*cos(angle)    #   + (innerRadius - @offset)         
      c2y = origy - @offset*sin(angle)    #   + (innerRadius - @offset)         
                  
      l1   = hypott(x,y, c1x,c1y)           + 80
      l2   = hypott(c2x,c2y, end_x,end_y)   + 50
      off1 = (angle_off x,y, c1x,c1y) - radians(10)
      
      off2 = (angle_off c2x,c2y, end_x,end_y) + radians(40)

			bezier x,y, x+cos(off1)*(l1),y+sin(off1)*(l1), end_x-cos(off2)*l2, end_y-sin(off2)*l2, end_x, end_y
      
      
      stroke 255,127,0
      #line x,y, c1x,c1y
      
      stroke 255,80,0
      #line c2x,c2y, end_x,end_y

      
      ellipse c2x,c2y, 5,5
      stroke 0,255,255
      #line x,y, x+cos(off1)*l1, y+sin(off1)*l1
      #line end_x-cos(off2)*l2, end_y-sin(off2)*l2, end_x, end_y
    end
    
    
    angle = radians 30
    fill 255,255,255

    points.times do |i|
			angle = angleChangePerPt * i
      x = origx + innerRadius * cos(angle)
			y = origy + innerRadius * sin(angle)
			
      rotation = angle
      translate x,y
      rotate rotation
      
      text "#{x}.00.0", 2,3
      
      rotate rotation*-1
      translate x*-1, y*-1
      angle += angleChangePerPt
    end
		@r += 0.01
		
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

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "PolygonGraph", :width => 700, :height => 700#, :full_screen => true
