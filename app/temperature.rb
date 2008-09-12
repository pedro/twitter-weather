class Temperature
  attr_accessor :degrees

  def initialize(degrees)
    @degrees = degrees
  end

  def qualify_change(new_temp)
    delta = (degrees - new_temp.degrees).abs
  
    case delta
      when 0:    false
      when 1:    :small
      when 2..3: :medium
      else       :big
    end
  end
end