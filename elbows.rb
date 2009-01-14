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
      
      @total_points = 4
      @current_point = 1
      puts "<<<<<<<<< start"
      puts starting.x
      draw_points 0,0
      puts ending.x
    ending.to_vertex
    endShape
    
    draw_dots
  end
  
  # have to distinguish if we're going left/right or up/down
  def draw_points x_offset, y_offset
    remaining_x_distance = x_diff - x_offset
    x_offset += remaining_x_distance/5

    remaining_y_distance = y_diff - y_offset
    y_offset += remaining_y_distance/2

    vertex starting.x + x_offset, starting.y + y_offset
    
    #dot.show :size => :random
    
    return if current_point == total_points
    
    @current_point += 1  
    draw_points x_offset, y_offset
  end
  
  def x_diff
    (ending.x - starting.x)
  end

  def y_diff
    (ending.y - starting.y)
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
