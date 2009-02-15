require 'ruby-processing'
require 'lib/position'
#require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  load_libraries :gemmings
  load_gem 'quinn-ruby-svg', :load_as => 'ruby-svg'
  
  include SVG::Processing
  
  attr_accessor :a,:z
  def setup
    setup_controls
    frame_rate 0.3
    
    smooth
    @a = Position.new
    @z = Position.new
    
    fill 0
    stroke_weight 0.2
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
      Circle.new a, 4
      Circle.new z, 4
      #Line.from_p a,z
      no_fill
      o1 = o
      o2 = o
      o3 = o
      o4 = o
      bezier a.x,a.y,a.x+o1,a.y+o2,z.x+o3,z.y+o4,z.x,z.y
      200.times do
        o1 += o 6
        o2 += o 6
        o3 += o 6
        o4 += o 6
        bezier a.x,a.y,a.x+o1,a.y+o2,z.x+o3,z.y+o4,z.x,z.y
      end
    end
    endShape

    if @creating_output
      @creating_output = false
      save_image_action
    end
  end
  
  def o x = 500
    (rand(x)-(x/2))
  end
  
  def radians deg
    deg.to_f*(PI/180)
  end
  
  def perp radian
    radian - radians(90)
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
