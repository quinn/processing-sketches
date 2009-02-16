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
    
    a = Position.new
    z = Position.new
    t = (3+rand(5))
    distance = a.y - z.y
    interval = distance/t.to_f
    Circle.new a, 7
    Circle.new z, 7
    
    
    t.times do
      dir = rand(2)
      jump = rand(interval*2)
      if dir == 0
        ellipse a.x
      else
        
      end
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

P = MySketch.new :title => "CrawlingTest", :width => 700, :height => 700#, :full_screen => true
