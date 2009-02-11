require 'ruby-processing'

class RandomShapes < Processing::App
  attr_accessor :shape, :timeout, :rotation
  load_libraries :'ruby-svg'
  def setup
    frame_rate 25
    @timeout = 0
    @rotation = 1.5
  end
  
  def draw
    background 200
    beginShape
    
    number_of_times = rand(20)
    shape_width = rand(width)
    shape_height = rand(height)
    
    if timeout == 0
      @shape = ""
      (rand(17)+3).times do
        @shape += "vertex #{rand(width)}, #{rand(height)} \n"
      end
      
      @timeout = 100
      @rotation = 1.5
      
      # log_shape
      puts @shape
      svg = SVG.new
      poly = SVGPolygon.new
      poly.instance_eval @shape
      svg.content << poly
      puts svg.to_xml
    else
      @timeout -= 1
    end
    
    reposition

    instance_eval @shape
    endShape CLOSE
  end
  
  def reposition
    translate(width/@rotation+70, height/@rotation-120)
    @rotation += 0.1
    rotate(PI / @rotation)
  end
  
  def log_shape
    log = File.open 'shapes.log', 'a'
    log << "\nCurrent Time: #{Time.now.to_s} \n"
    log << @shape
  end
end

RandomShapes.new :title => "Random Shapes", :width => 500, :height => 500
