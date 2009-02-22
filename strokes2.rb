require 'ruby-processing'
require 'lib/position'
require 'lib/trig'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  load_libraries :gemmings
  load_gem 'quinn-ruby-svg', :load_as => 'ruby-svg'
  
  include SVG::Processing
  include Trig
  
  attr_accessor :a,:z
  def setup
    setup_controls
    frame_rate 0.3
    
    smooth
    @a = Position.new
    @z = Position.new
    
    fill 0
    stroke_weight 5
    stroke 30, 180,10
    text_font create_font("Arial", 10)      
    @i = 0.0
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
      c.button :draw
    end
  end
  
  def draw
    reset
    beginShape
    (3+rand(20)).times do
      @z = a
      @a = Position.new
      fill 0
      no_stroke
      Circle.new a, 4
      Circle.new z, 4
      
      connect a, z
    end
    endShape

    if @creating_output
      @creating_output = false
      save_image_action
    end
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

class Circle
  def initialize position, radius
    P.ellipse position.x, position.y, radius, radius
  end
end

class Line
  def initialize x,y, length, rotation
    # nope
  end
  
  def self.from_p start,stop
    P.line start.x,start.y,stop.x,stop.y
  end
end

P = MySketch.new :title => "Strokes", :width => 700, :height => 700#, :full_screen => true
