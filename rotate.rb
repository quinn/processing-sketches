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
    frame_rate 30
    
    smooth
    no_stroke
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    reset
  	xPct = mouseX / width.to_f

    background(51);  
    #a = atan2(mouseY-y, mouseX-x).to_f; 

    translate(x, y); 
    rotate(radians(mouseX)); 
    stroke(255, 0, 0);  
    curve(500, 200, 0, 0, 300, 300, 500, 200);  
    begin_shape(); 
    vertex(100, 20); 
    vertex(50, 50); 
    vertex(30, 30); 
    end_shape(); 
    
    @ready_for_output = true
  end
  
  def radians deg
    deg*(PI/180)
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

P = MySketch.new :title => "Rotate", :width => 700, :height => 700#, :full_screen => true
