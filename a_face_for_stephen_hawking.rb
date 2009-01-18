# Description:
# Stephen Hawking's otherworldly mind is well represented by his
# computer-generated voice. Here, then, is a computer-generated face
# for Stephen Hawking.

require 'ruby-processing'

class FaceForStephenHawking < Processing::App
  load_ruby_library "boids"
  load_java_library "minim"
  load_java_library "opengl"
  load_java_library "angela_audio"
  include_package "processing.opengl"
  include_package "javax.media.opengl"
  include_class "audioInterp.AudioIn"
  include Math
  attr_accessor :flare, :star

  def setup
    render_mode OPENGL
    hint DISABLE_ERROR_REPORT
    hint ENABLE_OPENGL_4X_SMOOTH
    sphere_detail 7
    color_mode RGB, 1.0
    no_stroke
    frame_rate 30
    shininess 1.0
    specular 0.3, 0.1, 0.1
    emissive 0.03, 0.03, 0.1
    
    @flocks = []
    @particles = []
    @color = 0.5
    @radius = 50
    @analyzer = AudioIn.new(self)
    @analyzer.set_beat_detect_sensitivity(1000)
    @flare = load_image "flare.png"
    @star = load_image "star.png"
    3.times do |i|
      flock  = Boids.flock(10, 0, 0, width, height)
      flock.goal width/2, height/2, 100
      flock.no_perch
      boids = flock.boids
      @flocks << flock
    end
    background 0.05
  end
  
  def draw
    configure_gl
    ambient_light 0.51, 0.51, 0.65
    light_specular 0.2, 0.2, 0.2
    point_light 0.1, 0.1, 0.1, mouse_x, mouse_y, 100
    @particles.each do |particle|
      particle.update(@particles)
      particle.render
    end
    @flocks.each { |flock| render_flock(flock) }
  end
  
  def sample_sound
    amp = @analyzer.get_amp_left
    limit = 2 + (amp * 500)
    color = (@analyzer.get_frequency_band_left.to_f / 60.0)
    color > @color ? @color += 0.01 : @color -= 0.01
    radius = 32 + (amp * 2000)
    @radius = (@radius + radius) / 2
    explode = @analyzer.beat_detect_left
    [limit, @color, @radius, explode]
  end
  
  def render_flock(flock)
    limit, color, radius, explode = *sample_sound
    flock.update(:goal => 185, :limit => limit, :separation => 7 + (limit / 7))
    fill sin(color * PI * 2).abs, cos(color * PI * 2).abs, color
    flock.each { |boid| render_boid(boid, radius, explode) }
  end
  
  def render_boid(boid, r, explode)
    (r / 13).to_i.times { @particles << Particle.new(boid.x, boid.y, boid.z) } if explode
    push_matrix
    translate boid.x-r/2, boid.y-r/2, boid.z-r/2
    r += boid.z
    oval(r/2, r/2, r/3, r/3)
    image(@flare, 0, 0, r, r)
    pop_matrix
  end
  
  def configure_gl
    pgl = g
    gl = pgl.gl
    pgl.beginGL
    gl.gl_depth_mask(false)
    gl.gl_disable(GL::GL_DEPTH_TEST)
    gl.gl_clear(GL::GL_DEPTH_BUFFER_BIT)
    gl.gl_enable(GL::GL_BLEND)
    gl.gl_blend_func(GL::GL_SRC_ALPHA, GL::GL_ONE)
    pgl.endGL
  end  
end

class Particle
  def initialize(x, y, z)
    @x, @y, @z = x, y, z
    @vel = [0,0].map { rand * 50 - 25 }
    @radius = 7 + rand * 30
  end
  
  def update(particles)
    @vel = @vel.map {|v| v + (rand * 3 - 1.5)}
    @x += @vel[0]
    @y += @vel[1]
    if @x < 0 || @x > $app.width || @y < 0 || @y > $app.height
      particles.delete(self)
    end
  end
  
  def render
    $app.push_matrix
    $app.translate @x, @y, @z
    $app.image($app.star, 0, 0, @radius, @radius)
    $app.pop_matrix
  end
end

$app = FaceForStephenHawking.new :title => "A Face for Stephen Hawking", 
      :width => 1400, :height => 700, :full_screen => true