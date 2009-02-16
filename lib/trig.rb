module Trig
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

  def perp radian
    radian - radians(90)
  end
end
