require 'ruby-processing'

class MySketch < Processing::App
  attr_accessor :i
  
  def setup
    setup_controls
    frame_rate 0.1
    smooth
    no_stroke
    
    fill 0
    text_font create_font("Bell Gothic Std Black", 24.7)

    text "FRONT", 0,height
    save_frame("gmtest-####.png")
    
    draw
  end
  
  def setup_controls
    # control_panel do |c|
    #   c.button :output_svg
    # end
  end
  
  def draw
  end
  
  def output_svg
  end
  
  def reset
    reset_svg
    background 200
  end
end

P = MySketch.new :title => "GenerateMenu", :width => 89, :height => 36#, :full_screen => true
