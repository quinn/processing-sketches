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
    frame_rate 1
    
    smooth
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    reset

    20.times do |n|
      n += 1
      fill 0
      text_font create_font("Arial", 10)
      
      text "#{n*10}.00", 85, n*20+3
      line 50, n*20, 80, n*20
      ellipse 50, n*20, 2, 2
    end
    line 50, 20, 50, 400
    
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

P = MySketch.new :title => "FakeGraphs", :width => 500, :height => 500#, :full_screen => true
