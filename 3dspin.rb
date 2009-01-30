require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  load_libraries :opengl, :minim, :control_panel
  include_package "processing.opengl"
  import "ddf.minim.Minim"
  
  attr_accessor :minim, :input, :sensitivity
  
  def setup
    render_mode OPENGL
    hint ENABLE_OPENGL_4X_SMOOTH
    frame_rate 30
    
    control_panel do |c|
      c.slider :sensitivity, 500..10000
    end
    @sensitivity = 1000
    @bg_switch = 0
    @squares = [FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new,FloatySquare.new]
    @minim = Minim.new self
    @input = minim.get_line_in
    
    no_stroke
    draw
  end
  
  def draw
    @bg_switch += 1
    background 255,255,255  if @bg_switch/3 == @bg_switch/3.0
    rotate_view
  end
  
  def rotate_view
    translate(width/2, height/2);
    @squares.each{|s| s.show}
  end
end

class FloatySquare
  def initialize
    @fill = fill_brights
    %w{x y z}.each do |v|
      send "do_#{v}_stuff"
    end
  end
  %w{x y z}.each do |v|
    eval "
      attr_accessor :scalar_#{v}, :#{v}
      def do_#{v}_stuff
        @scalar_#{v} = (rand(10)+1)/100.0
        @#{v} = rand(10)/10.0
      end

      def rotate_#{v}
        @#{v} -= @scalar_#{v}
        P.rotate_#{v} @#{v}
      end
    "
  end
  
  def show
    P.fill @fill
    %w{x y z}.each do |v|
      send "rotate_#{v}"
    end
    
    m = (P.input.mix.level*P.sensitivity).to_i
    P.rect(m,m, m,m)
  end
  
  def fill_brights
    colors = []
    colors << [255,0,0]     # red
    colors << [0,255,0]     # green
    colors << [0,0,255]     # blue
    colors << [0,255,255]   # cyan
    colors << [255,255,0]   # yellow
    colors << [255,0,255]   # magenta
    colors << [255,127,0]   # orange
    #colors << [0,0,0]       # black
    #colors << [255,255,255] # white
    
    fill_with = colors.shuffle!.first
    fill_with ||= [255,255,255]
    P.color *(fill_with)
  end
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "Stripes", :width => 500, :height => 500#, :full_screen => true
