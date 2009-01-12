require 'ruby-processing'

class Colors < Processing::App
  attr_accessor :i
  def setup
    @i = 0xFF000000
  end
  
  def draw
    fill i
    @i += 0xFFF
    rect -1, -1, width+1, height+1  
  end
  
end

Colors.new :title => "Colors", :width => 500, :height => 500