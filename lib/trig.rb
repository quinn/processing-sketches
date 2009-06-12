module Trig
  include Math
  def angle_off startx,starty,endx,endy
    theight = (starty - endy)
    twidth  = (startx - endx)
    angle = atan(twidth.to_f/theight)
    # i have no idea what these next 3 lines do
    # i just wrote them
    offset = (twidth > 0) ? radians(180) : 0
    offset -= ((theight > 0) and !(twidth > 0)) ? radians(180) : 0
    offset += (!(theight > 0) and (twidth > 0)) ? radians(180) : 0
  
    offset_angle = offset + radians(90) - angle
  end

  def hypott startx,starty,endx,endy
    theight = (starty - endy)
    twidth  = (startx - endx)
    length = Math.sqrt(twidth**2 + theight**2)
    length
  end

  def radians deg
    deg.to_f*(PI/180)
  end

  def degrees radian
    radian/(PI/180.0)
  end

  def perp radian
    radian - radians(90)
  end
  
  def connect start, finish, color = [30, 180,10], thickness = 20, stroke_thickness = 3
    a = start ; z = finish
    
    push_style
    stroke *color
    stroke_weight stroke_thickness
    no_fill
    
    o1 = o
    o2 = o
    o3 = o
    o4 = o
    bezier a.x,a.y,a.x+o1,a.y+o2,z.x+o3,z.y+o4,z.x,z.y
    thickness.times do
      o1 += o 6
      o2 += o 6
      o3 += o 6
      o4 += o 6
      bezier a.x,a.y,a.x+o1,a.y+o2,z.x+o3,z.y+o4,z.x,z.y
    end

    pop_style
  end
  
  def o x = 500
    (rand(x)-(x/2))
  end
end

