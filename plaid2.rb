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
    frame_rate 30
    no_stroke
    smooth
    
    @offset = -400
    @prev_fill = brights
    @rotation = radians(45)
    @translation = [0,0]
    
    @offm  = []
    @poffm = []
    @soffm = []
    amount.times{ @offm  << 0 }
    amount.times{ @poffm << 0 }
    amount.times{ @soffm << 0 }
    
    @cyan = [0,255,255]   #if @cyan
    @magenta = [255,0,255]   #if @magenta
    @black = [0,0,0]       #if @black
    @white = [255,255,255] #if @white
    @fillings = [[@cyan,     @black],
                 [@magenta,  @white]]
    @i = 0
    
    background 68, 70, 73
    text_font create_font("Arial", 10)
    draw
  end
  
  def setup_controls
    control_panel do |c|
    end
  end
  
  def draw
    new_fill = brights
    while (new_fill == @prev_fill)
      new_fill = brights
    end
    
    @prev_fill = new_fill
    
    qx = cos(@rotation).oned
    qy = sin(@rotation).oned
    
    @translation = qx.switch*width, qy.switch*height
    
    push_matrix
    
    translate *@translation
    rotate @rotation
    # fill *new_fill
    
    puts @fillings.inspect
    puts 'asdfasdf'
    puts @fillings[0][0].inspect
    puts @fillings[0][1].inspect
    puts @fillings[1][0].inspect
    puts @fillings[1][1].inspect
    
    fill *(@fillings[qx][qy] + [100])
    
    rect 0, @offm[@i]+2, P.width+300, @poffm[@i]
    @poffm[@i] = 3#rand(100)/20.0
    @offm[@i] += @soffm[@i]+0.8
    @soffm[@i] = @poffm[@i]
    
    pop_matrix
    # text_overlay
    iterate
  end
  
  def amount; 11; end
  
  def iterate
    @rotation += radians(360.0/amount)
    cycle_amount
  end
  
  def cycle_amount
    @i += 1
    @i = 0 if @i == amount
    @i
  end
  
  def make_offset
    20#rand(20)+2
  end
  
  def text_overlay
    fill 255,255,255, 200
    rect 27,27,170,80
    fill 0
    texting "offset is: #{@offset}\n"
    texting "thickness is: #{@thickness}\n"
    texting "sin is: #{sin(@rotation).oned}\n"
    texting "cos is: #{cos(@rotation).oned}\n"
    @text_offset = nil
  end
  
  def texting str
    @text_offset ||= 39
    text str, 32, @text_offset
    @text_offset += 12
  end
  
  include Capture
  
  def fill_brights
    fill *brights
  end
  
  def brights
    colors = []
    #colors << [255,0,0]     #if @red
    # colors << [0,255,0]     #if @green
    # colors << [0,0,255]     #if @blue
    # colors << [255,255,0]   #if @yellow
    # colors << [255,127,0]   #if @orange
    colors << [154,215,74]
    colors << [74,160,215]
    colors << [215,74,121]
    
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

class Float
  def oned
    return 0 if self <= 0
    return 1
  end
end

class Fixnum
  def switch
    return 1 if self == 0
    return 0
  end
end

P = MySketch.new :title => "Plaid", :width => 500, :height => 500, :full_screen => true
