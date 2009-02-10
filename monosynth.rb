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
  
  attr_accessor :minim, :input, :output, :waves, :mousy
  
  def setup
    render_mode OPENGL
    frame_rate 30

    @minim = Minim.new self
    @input = minim.get_line_in
    @output = minim.get_line_out
    @wavelength = 100
    @waves = (1..2).collect{ s= TriangleWave.new(@wavelength, 0.5, 44100); s.portamento(25); s}
    @filter = NotchFilter.new @wavelength, 100, 44100
    @mousy = Position.new :mouse
    waves.each{|w| output.add_signal w}
    
    no_stroke
    #draw
  end
  
  def draw
    @wavelength = @mousy.x/3 + 50
    waves.each_with_index do |wave,i|
      if i > 0
        subtractor = (@wavelength/(3*i))
      else
        subtractor = 0
      end
      wave.set_freq @wavelength - subtractor
    end
    track_pos
  end
  
  def track_pos
    rect @mousy.x, @mousy.y, 300, 100
  end
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "Stripes", :width => 500, :height => 500, :full_screen => true
