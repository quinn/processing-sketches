require 'ruby-processing'
require 'lib/position'
require 'lib/dot'
require 'lib/trig'
require 'lib/mixins/capture'
require 'net/http'
require 'yaml'

class Object
  def tap &blk
    instance_eval &blk
    self
  end
end

class MySketch < Processing::App
  load_libraries :control_panel, :json, :nyt_processing
  import "org.json"
  include Trig
  attr_accessor :minim, :input, :sensitivity, :words, :results, :colors
  
  def setup
    frame_rate 0.5
    @bg_switch = 0
    no_stroke
    
    smooth
    
    text_font create_font("Arial", 10)
    
    @words = 'japan', 'china'
    @results = {}
    @colors  = {}

    get_data
    make_chart
    draw
  end
  
  def get_data
    # ?query=japan%20publication_year:[1981]%20publication_month:[12]&fields=+&facets=org_facet
    start = 1981
    stop  = 1992
    threads = []
    
    words.each do |word|
      results[word] = []
      colors[word]  = fill_brights(100)
    end
    
    words.each do |word|
      (stop-start).times do |offset|
        year = start + offset
      
        12.times do |month|
          threads << Thread.new do
            month += 1
          
            search = TimesArticleSearch.new.tap do
              queries << 'japan'
              monthstr = (month > 9) ? month.to_s : ("0#{month}")
              facet_queries << "publication_year:[#{year}]" << "publication_month:[#{monthstr}]"
              fields  << "+"
              facets  << "org_facet"
            end
            
            results[word] << search.do_search
          end
        end
      end
    end
    
    threads.each{|th| th.join} 
  end
  
  def draw
    
  end
  
  def make_chart
    background 80
    
    step_size = width.to_f / results[words.first].length
    
    direction = true
    words.each do |word|
      if direction
        direction = false
      else
        direction = true
      end

      results[word].each_with_index do |result,i|
        if result
          push_matrix
          offset = step_size * i
          
          translate offset, height/2

          fill *colors[word]
          
          if direction
            rect 0,result.total*-1, step_size-1.0, result.total
            
            result.get_facet_list('org_facet').each_with_index do |facet,i|
              foff = 10*i
              fill 80
              push_matrix
              rotate radians(-90)
              text facet.term, 0, foff
              pop_matrix
            end
          else
            rect 0,0, step_size-1.0, result.total

            facet = result.get_facet_list('org_facet').first
            push_matrix
            fill 0
            translate step_size, result.total-2
            #rotate radians(rand(180))
            text facet.term, 0, 0
            pop_matrix

            # result.get_facet_list('org_facet').each_with_index do |facet,i|
            #   foff = 10*i
            #   fill 0
            #   push_matrix
            #   translate step_size-1.0, result.total
            #   rotate radians(rand(180))
            #   text facet.term, 0, 0
            #   pop_matrix
            # end
          end
          #puts result.facets.inspect
          pop_matrix
        end
      end
    end
    
    # result_file.write Marshal.dump( results )
    # result_file.close_write
    # exit
  end

  def fill_brights opacity = 255
    colors = []
    colors << [255,0,0]     # red
    colors << [0,255,0]     # green
    colors << [0,0,255]     # blue
    colors << [0,255,255]   # cyan
    colors << [255,255,0]   # yellow
    colors << [255,0,255]   # magenta
    colors << [255,127,0]   # orange
    #colors << [0,0,0]       # black
    #colors << [255,255,255] # white
    
    fill_with = colors.shuffle!.first
    fill_with ||= [255,255,255]
    fill_with << opacity
    #fill *(fill_with)
    fill_with
  end
end

class FloatySquare
  def initialize
    @fill = fill_brights
    %w{x y z}.each do |v|
      send "do_#{v}_stuff"
    end
  end
  %w{x y z}.each do |v|
    eval "
      attr_accessor :scalar_#{v}, :#{v}
      def do_#{v}_stuff
        @scalar_#{v} = (rand(10)+1)/100.0
        @#{v} = rand(20)/10.0
      end

      def rotate_#{v}
        @#{v} -= @scalar_#{v}
        P.rotate_#{v} @#{v}
      end
    "
  end
  
  def show
    P.fill @fill
    %w{x y z}.each do |v|
      send "rotate_#{v}"
    end
    @prev_m ||= 0
    m = (P.input.mix.level*P.sensitivity)
    m = (@prev_m-m).abs < 12.0 ? @prev_m : m
    P.rect(m,m,m,m)
    @prev_m = m
  end
  
end

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

P = MySketch.new :title => "NYTParse", :width => 800, :height => 700#, :full_screen => true
