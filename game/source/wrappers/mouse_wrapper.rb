# frozen_string_literal: true
#
class MouseWrapper
  attr_accessor :mouse
  def initialize(mouse)
    @mouse = mouse
  end

  def over_any?(array)
    array.each do |elem|
      return elem if mouse.over?(elem.rectangle)
    end

    nil
  end

  def mouse_clicked?(rectangle)
    mouse.button_down?(:left).eql?(1) && mouse.over?(rectangle)
  end
end
