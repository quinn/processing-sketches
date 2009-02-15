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
    frame_rate 40
    
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
    
    startx = 200
    starty = 50
    endx   = 300
    endy   = 500
    
    theight = (starty - endy).abs
    twidth  = (startx - endx).abs
    length = Math.sqrt(twidth**2 + theight**2)
    
    angle = atan(twidth.to_f/theight)
    offset_angle = radians(90) - angle
    
    stroke 0,0,0
    line startx,starty,endx,endy
    
    stroke 255,0,0
    line startx,starty,startx,endy
    line startx,endy,endx,endy

    @i = offset_angle #+= 0.01
    line startx,starty,startx+cos(@i)*length, starty+sin(@i)*length 
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

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "PolygonGraph", :width => 700, :height => 700#, :full_screen => true
