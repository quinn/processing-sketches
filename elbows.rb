require 'ruby-processing'
require 'lib/position'
require 'lib/dot'

class Elbows < Processing::App
  attr_accessor :starting_dot, :ending_dot, :starting, :ending, :joints, 
    :current_point, :total_points, :mousy
    
  def setup    
    @starting_dot = Dot.new
    @ending_dot = Dot.new
    @joints = 1
    frame_rate 30
    smooth
    make_positions
    draw
    
  end
  
  def draw_background
    fill 200
    rect -1, -1, P.width+1, P.height+1    
  end
  
  def make_positions
    @starting = Position.new
    @ending = Position.new
    @mousy = Position.new nil, :follow => :mouse
  end
  
  def draw
    draw_background
    noFill
    beginShape
    starting.to_vertex
      @total_points = 10
      @current_point = 1
      direction = ((rand 2) == 0) ? :vert : :horiz
      
      draw_points 0,0, direction
    ending.to_vertex
    endShape
    
    draw_dots
  end
  
  # have to distinguish if we're going left/right or up/down
  def draw_points x_offset, y_offset, orientation
    if orientation == :vert
      orientation = :horiz
      remaining_x_distance = x_diff - x_offset
      x_offset += relative_rand(remaining_x_distance)
      if current_point == total_points
        return vertex ending.x, starting.y + y_offset
      end
    else
      orientation = :vert
      remaining_y_distance = y_diff - y_offset
      y_offset += relative_rand(remaining_y_distance)
      if current_point == total_points
        return vertex starting.x + x_offset, ending.y
      end
    end
    vertex starting.x + x_offset, starting.y + y_offset
    
    return if current_point == total_points
    
    @current_point += 1
    draw_points x_offset, y_offset, orientation
  end
  
  def x_diff
    (ending.x - starting.x)
  end

  def y_diff
    (ending.y - starting.y)
  end
  
  def draw_dots
    starting_dot.shift starting
    starting_dot.show
    ending_dot.shift ending
    ending_dot.show :fill_color => [100] # end point is grey
  end
  
  def relative_rand num
    r = rand num
    return r if num.abs == num
    r * -1  
  end
  
  def mouse_pressed
    starting.follow = :mouse if starting_dot.clicked?
    ending.follow = :mouse if ending_dot.clicked?
  end
  
  def mouse_released
    starting.follow = nil
    ending.follow = nil
  end
end

class Line
  attr_accessor :start, :ending
  
  
end
P = Elbows.new :title => "My Sketch", :width => 600, :height => 500
