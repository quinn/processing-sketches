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
    frame_rate 5
    
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
  	yPct = mouseY / height.to_f

  	nTips = (5 + xPct * 60).to_i
  	nStarPts = (nTips * 2).to_i
  	angleChangePerPt = TWO_PI / nStarPts
  	innerRadius = 0 + yPct*80;
  	outerRadius = 80;
  	origx = width/2;
  	origy = height/2;
  	angle = 30;

  	begin_shape
  	nStarPts.times do |i|
      i -= 1
  		if (i % 2 == 0)
  			x = origx + innerRadius * cos(angle);
  			y = origy + innerRadius * sin(angle);
  			vertex x, y
  		else
  			x = origx + outerRadius * cos(angle);
  			y = origy + outerRadius * sin(angle);
  			vertex x, y
  		end
  		angle += angleChangePerPt;
  	end
	  end_shape
    
    @ready_for_output = true
  end
  
  def output_svg
    unless ready_for_output
      puts "\033[1mwarning: not ready for output\033[0m"
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

P = MySketch.new :title => "Star", :width => 900, :height => 900#, :full_screen => true
