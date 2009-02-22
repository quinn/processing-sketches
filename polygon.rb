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

  	nStarPts = (3+xPct * 20).to_i
  	angleChangePerPt = TWO_PI / nStarPts
  	innerRadius = 300
  	origx = width/2
  	origy = height/2
  	angle = 30;

  	begin_shape
  	nStarPts.times do |i|
			x = origx + innerRadius * cos(angle);
			y = origy + innerRadius * sin(angle);
			vertex x, y
  		angle += angleChangePerPt;
  	end
	  end_shape
    
    @ready_for_output = true
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

P = MySketch.new :title => "Polygon", :width => 700, :height => 700#, :full_screen => true