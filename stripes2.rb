require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/trig'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  include Trig
  
  def setup
    setup_controls
    frame_rate 20
    no_stroke
    smooth
    @offset = -400
    @prev_fill = brights
    @rotation = radians(45)
    @translation = [0,0]
    @left_lines = []
    @right_lines = []
    @i = 0
    background 255#255,100,200
    text_font create_font("Arial", 10)
    draw
  end
  
  def setup_controls
    control_panel do |c|
    end
  end
  
  def draw
    if !@stop
    
      new_fill = brights
      while (new_fill == @prev_fill)
        new_fill = brights
      end
      @prev_fill = new_fill

      @previous_thickness = @thickness
      @thickness = rand(5) + 3
      @offset = @offset + @previous_thickness.to_i + 2

      draw_line @rotation, @translation, @offset, @thickness, new_fill
    
      fill 255
      rect 27,27,100,80
      fill 0
      text "offset is: #{@offset}\n", 32,39
      text "thickness is: #{@thickness}\n", 32,51

      if @offset > 350
        @stop = true if @stopping
        @offset = -400
        @rotation = radians(-45)
        @translation = [width/-2-100,height/2+100]
        @stopping = true
      end
    elsif !@really_stopped
      lay_lines
    end
  end
  
  def lay_lines
    @really_stopped = true unless (!@right_lines.empty? or !@left_lines.empty?)
    @i += 1
    if (@i % 2 == 0)
      pr = @left_lines.pop
    else
      pr = @right_lines.pop
    end
    pr.call if pr        
  end
  
  def draw_line r, t, off, thickness, fc
    arr = if @stopping
      @right_lines << Proc.new do
        push_matrix
        rotate r
        translate *t
        fill *fc
        rect 0, off, P.width+300, thickness
        pop_matrix
      end
    else
      @left_lines << Proc.new do
        push_matrix
        rotate r
        translate *t
        fill *fc
        rect 0, off, P.width+300, thickness
        pop_matrix
      end
    end
  end
  
  include Capture
  
  def fill_brights
    fill *brights
  end
  
  def brights
    colors = []
    # colors << [255,0,0]     #if @red
    colors << [0,255,0]     #if @green
    # colors << [0,0,255]     #if @blue
    colors << [0,255,255]   #if @cyan
    # colors << [255,255,0]   #if @yellow
    colors << [255,0,255]   #if @magenta
    #colors << [255,127,0]   #if @orange
    # colors << [0,0,0]       #if @black
    # colors << [255,255,255] #if @white
    
    fill_with = colors.shuffle!.first
    fill_with ||= [255,255,255]
    fill_with
  end
end

class Circle
  def initialize position, radius
    P.ellipse position.x, position.y, radius, radius
  end
end

class Stripe
  def initialize thickness
    P.rect 0, ( thickness ), P.width+200, P.height
  end
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "Plaid", :width => 500, :height => 500#, :full_screen => true
