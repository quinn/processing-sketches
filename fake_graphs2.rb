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

    text_font create_font("Arial", 10)
    
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
      stroke_weight 2
      
      #text "#{n*10}.00", 85, n*20+3
      if n % 4 == 0
        line 50, n*20, 60, n*20
      elsif n % 2 == 0
        line 50, n*20, 65, n*20
      else
        line 50, n*20, 55, n*20
      end
      line 50, n*20+10, 55, n*20+10
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

P = MySketch.new :title => "FakeGraphs2", :width => 500, :height => 500#, :full_screen => true
