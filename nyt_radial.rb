require 'ruby-processing'
require 'net/http'

BaseURL = "http://api.nytimes.com/svc/search/v1/article"
ApiKey  = "7ea86ecc92866e9cf37c5f16cd205356:2:57988907"

class MySketch < Processing::App
  load_libraries :json
  import "org.json"
  
  def setup
    @facetString = "org_facet"     # Type(s) of facet to include in the search
                              
    @maxVal = 0                    # Keeps track of the maximum returned value over the all terms
    @localMax = 0                  # Keeps track of the maximum returned value over the each term
    @totalMonths = 0               # Counter for months to be drawn
    @drawHeight = 0.65             # Portion of the screen height that the largest bar takes up
                              
    @border = 1                    # Border between bars
    @lastTotal = 0                 

                              
    @s = 1981                      # Start Year
    @e = 1982                      # End Year
    @words = ["japan", "china"]    # Search Terms
    @colors = color(64,1,1), color(140,67,3) # Graph colors
    @textColor = color(217,141,48)         
    @backColor = [242,242,242]
    @curColor = nil                
                              
    @refresh = false               # Determines wether each term has it's own max value
  
    # Load the font to be used in text display
    text_font create_font("Arial", 10)      
  
    # Set the size of the stage & set the background
    background(*@backColor)
    smooth
  
    # Draw key
    textSize(24)
    @words.length.times do |i|
      fill(@colors[i])
      text(@words[i],25, 45 + (i * 30))
    end
    fill(@textColor)
    text(@s.to_s + "-" + @e.to_s, 25, 45 + (@words.length * 30))
  
    # For each keyword, request a TimesDataChunk and draw it.
    @words.length.times do |i|
      @localMax = 0
      @totalMonths = 0
      fill(@colors[i])
      @curColor = @colors[i]
      months = buildMonthArray(@words[i], @s, @e)
      drawMonths(months)
      @maxVal = 0 if (@refresh)
    end  

    # Save out an image when the whole process is finished
    save(@words[0] + "_" + @s.to_s + "_" + @e.to_s + ".png")
  end

  def draw
  
  end

  def drawMonths(monthArray)
 
    xinc = width.to_f/@totalMonths
  
    # Move to the center of the screen
    pushMatrix
    translate(width/2, height/2)
    noStroke
  
    # Draw each month as a bar
    @words.length.times do |i|
      c = color(red(@curColor), green(@curColor), blue(@curColor), random(100,255))
      fill(c)
      puts monthArray.inspect
      dc = monthArray[i]
      h = dc.total.to_f/@maxVal.to_f
      theta = i * (PI / (@totalMonths/2.0))
    
      # Rotate
      pushMatrix
      rotate(theta)
      # Draw the bar
      rect(0, 0,xinc, -h * height * @drawHeight)
      y = -( h * height * @drawHeight.to_f)
      x = 0.0
    
      # Mark maximum points
      if (dc.isSpike)
      
        rect(x, y - (xinc * 2), xinc/2, xinc/2) 
        s = dc.cmonth + "/" + dc.cyear
      
        pushMatrix
        translate(x + xinc/2, y - (xinc * 2))
      
        # Draw date
        rotate(-PI/2)
        fill(@textColor)
        textSize(max(xinc/2, 13))
        text(s, 0,0)
      
        translate( 50, 0)
        
        # Draw org facets
        if dc.facetStrings.length > 0
          min(dc.facetStrings.length,3).times do |j|
            color c2 = color(red(@textColor), green(@textColor), blue(@textColor), random(100,150))
            fill(c2)
            t = dc.facetStrings[j]
            textSize(random(6,10))
            pushMatrix
            translate(0,0)
            rotate( random(-0.5, 0.5) )
            text(t, random(10), 0)
            popMatrix
           end
        end
        popMatrix
      
      end
      popMatrix
    end
    popMatrix

  end
  
  
  def max left, right
    if left > right
      left
    else
      right
    end
  end
  
  def min left, right
    if left < right
      left
    else
      right
    end
  end
  
  def buildMonthArray(word, startYear, endYear)
    # Find out how many months are going to be stored
    months = (endYear - startYear) * 12
    mArray = []
    
    months.times do |j|
      i = j % 12
      y = startYear +  (j / 12).floor                # GET YEAR
      m = (i + 1 < 10) ? "0" + (i + 1).to_s : (i + 1).to_s  # GET MONTH
    
      @totalMonths += 1
    
      dc2 = getChunk(word, y.to_s, m)                         # REQUEST DATA CHUNK
      mArray[j] = dc2                                         # ADD DATA CHUCK TO MONTH ARRAY
    
      puts ("PROCESSED " + j.to_i.to_s + " OF " + months.to_i.to_s)
    end
    return(mArray)
  end

  def getChunk(word, y, m)
    url = BaseURL + "?query=" + word + "%20publication_year:[" + y + "]%20publication_month:[" + m + "]&fields=+&facets=" + @facetString + "&api-key=" + ApiKey
    puts url
    dc = TimesDataChunk.new
    begin
      
      nytData = JSONObject.new Net::HTTP.get( URI.parse(url) )
      facets = nytData.getJSONObject("facets")
      dc.facets = facets.getJSONArray("org_facet")
    
      dc.facetStrings = []
      dc.facets.length.times do |i|
        o = dc.facets.get(i)
        dc.facetStrings[i] = o.getString("term")
      end
  
      dc.total = nytData.getInt("total")
      if dc.total > @localMax
        @localMax = (dc.total > width) ? width : dc.total
        @maxVal = @localMax if (@localMax > @maxVal)
      end
    
      if (dc.total > @lastTotal.to_f * 1.2)
        dc.isSpike = true
      end
      @lastTotal = dc.total
      dc.cyear =  y
      dc.cmonth = m   
    rescue JSONException => e
      puts (e.to_s)  
    end 
  
    dc
  end

end

class TimesDataChunk
  attr_accessor :cyear, :cmonth, :facetStrings, :word, :leadFacet, :secondFacet, :isSpike, :total, :facets, :entries
  
  def initialize
  end
end

P = MySketch.new :title => "NYTParse", :width => 800, :height => 700#, :full_screen => true






