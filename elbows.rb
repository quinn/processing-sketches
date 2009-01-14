require 'ruby-processing'
require 'lib/position'
require 'lib/dot'

class Elbows < Processing::App
  attr_accessor :dot, :starting, :ending, :joints, :current_point, :total_points
  def setup
    @dot = Dot.new
    @joints = 1
    frame_rate 0.1
    smooth
    draw
  end
  
  def draw_background
    fill 200
    rect -1, -1, P.width+1, P.height+1    
  end
  
  def make_positions
    @starting = Position.new
    @ending = Position.new    
  end
  
  def draw
    draw_background
    make_positions
    noFill
    beginShape
    starting.to_vertex
      
      x_offset = starting.x
      @total_points = 2
      @current_point = 1
      
      draw_points 20
    ending.to_vertex
    endShape
    
    draw_dots
  end
  
  # have to distinguish if we're going left/right or up/down
  def draw_points offset
    remainder = y_diff + offset
    
    if current_point == total_points # last point
      return vertex ending.x, ending.y+remainder
    elsif current_point == 1 # 1st point
      vertex starting.x, starting.y+offset
    else # middle points
      vertex starting.x-x_diff/2, starting.y+offset
    end
    
    @current_point += 1  
    draw_points offset
  end
  
  def x_diff
    (starting.x - ending.x)
  end

  def y_diff
    (starting.y - ending.y)
  end
  
  def draw_dots
    dot.shift starting
    dot.show
    dot.shift ending
    dot.show :fill_color => [100] # end point is grey
  end
end

class Line
  attr_accessor :start, :ending
  
  
end
P = Elbows.new :title => "My Sketch", :width => 600, :height => 500
