require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  attr_accessor :i
  
  def setup
    setup_controls
    frame_rate 1
    no_stroke
    smooth
    @opacity = 100
    @thickness = 100
    
    
    @red     = true
    #@green   = true
    #@blue    = true
    #@cyan    = true
    #@yellow  = true
    #@magenta = true
    #@orange  = true
    #@black   = true
    #@white   = true
    
    reset_i
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.slider(:opacity, 0..255)
      c.slider(:thickness, 30..500)
      c.checkbox :red
      c.checkbox :green
      c.checkbox :blue
      c.checkbox :cyan
      c.checkbox :yellow
      c.checkbox :magenta
      c.checkbox :orange
      c.checkbox :black
      #c.checkbox :white
    end
  end
  
  def draw
    #background 255,255,255
    reset_i
    recurse_stripe
    
    load_pixels
    height.times do |i|
      #puts "#{pixels[0] - pixels[i*width]}"
      if (pixels[0] - pixels[i*width]).abs < 100000 and i > 30
        pattern = get 0, 0, width, i
        (height/i+1).times do |ii|
          image pattern, 0, i*ii
        end
        #fill 0,0,0
        #rect 0, i*2, 1000,1000
        break;
      end
    end
    
    #update_pixels
    # fill pixels[0]
    # rect(30, 20, 55, 55)
  end
  
  def with_pixels range, &blk
    load_pixels
    range.each do |i|
      pixels[i] = blk.call i
    end
    update_pixels
  end
  
  def drawing_stripe
    @i -= rand(@thickness)/10.0
    return if @i < ((P.height+200) * -1)
    fill_brights
    Stripe.new @i    
  end
  
  def recurse_stripe
    recurse_stripe if drawing_stripe
  end
  
  def reset_i
    @i = 0
  end
  
  include Capture
  
  def t55
    return 0 if rand(2) == 0
    255
  end
  
  def fill_brights
    colors = []
    colors << [255,0,0]     if @red
    colors << [0,255,0]     if @green
    colors << [0,0,255]     if @blue
    colors << [0,255,255]   if @cyan
    colors << [255,255,0]   if @yellow
    colors << [255,0,255]   if @magenta
    colors << [255,127,0]   if @orange
    colors << [0,0,0]       if @black
    colors << [255,255,255] if @white
    
    fill_with = colors.shuffle!.first
    fill_with ||= [255,255,255]
    fill *(fill_with.push rand(@opacity))
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
P = MySketch.new :title => "Stripes", :width => 500, :height => 500#, :full_screen => true
