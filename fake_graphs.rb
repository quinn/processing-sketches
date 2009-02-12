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
    #no_stroke
    smooth
    draw
  end
  
  def setup_controls
    control_panel do |c|
      c.button :output_svg
    end
  end
  
  def draw
    background 200
    rand(20).times do |n|
      xoffset = rand(n*n) + 20
      yoffset = rand(n*n) + 1
      20.times do |n|
        n += yoffset
        line xoffset, n*10, xoffset+30, n*10
      end
    end
  end
  
  def output_svg    
    puts to_svg.to_s
    reset_svg
    background 127
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
    #fill *([255,0,0].shuffle!.push rand(100))
  end
  include Capture
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end
P = MySketch.new :title => "FakeGraphs", :width => 500, :height => 500#, :full_screen => true
