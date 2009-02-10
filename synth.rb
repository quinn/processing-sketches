require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/mixins/capture'

class MySketch < Processing::App
  load_libraries :opengl, :minim, :control_panel
  include_package "processing.opengl"
  import "ddf.minim"
  import "ddf.minim.signals"
  import "ddf.minim.effects"
  
  attr_accessor :minim, :input, :output, :waves
  
  def setup
    render_mode OPENGL
    frame_rate 10

    @minim = Minim.new self
    @input = minim.get_line_in
    @output = minim.get_line_out
    
    #lowpass = LowPassSP.new 200, 44100    
    #output.add_effect lowpass

    @wavelength = rand(1) + 100
    @waves = (1..3).collect{SawWave.new(@wavelength, 0.5, 44100)}
    waves.each{|w| output.add_signal w}

    no_stroke
    draw
  end
  
  def draw
    @p_wavelength = @wavelength
    if (@wavelength > 5000 or rand(2) == 0) and (@wavelength > 50)
      @wavelength = @p_wavelength / 3
    else
      @wavelength = @p_wavelength * 3
    end
    
    waves.each_with_index do |wave,i|
      if i > 0
        subtractor = (@wavelength/(3*i))
      else
        subtractor = 0
      end
      wave.set_freq @wavelength - subtractor
    end
    background 255,255,255
  end
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "Stripes", :width => 500, :height => 500#, :full_screen => true
