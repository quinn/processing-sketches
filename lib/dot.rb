class Dot
  attr_accessor :x_offset, :y_offset
  
  def initialize
    self.x_offset = 100
    self.y_offset = 100
  end
  
  def shift *args
    if args.length > 1
      self.x_offset = args[0]
      self.y_offset = args[1]
    else
      pos = args[0]
      self.x_offset = pos.x
      self.y_offset = pos.y
    end
  end
  
  def show opts = {}
    fill_color = opts.delete :fill_color
    size = opts.delete :size
    
    if fill_color
      P.fill *fill_color
    else
      P.fill 255,255,255
    end
    if size
      P.ellipse x_offset, y_offset, 20+rand(20), 20+rand(20)
      P.fill 0,0,0
      P.ellipse x_offset, y_offset, 3+rand(5), 3+rand(5)
    else
      P.ellipse x_offset, y_offset, 20, 20
      P.fill 0,0,0
      P.ellipse x_offset, y_offset, 3, 3
    end
  end
  
  def clicked?
    puts P.mouseX
    puts x_offset
    P.mouseX > x_offset - 10 and P.mouseX < x_offset + 10 and
    P.mouseY > y_offset - 10 and P.mouseY < y_offset + 10
  end
end
