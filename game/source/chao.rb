# frozen_string_literal: true

class Chao
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :number

  def initialize
    @azulejos = [Azulejo.new(250, 250, "token")]
    @x = 180
    @y = 180
    @width = 126
    @height = 25
    @asset = Sprite.new(x, y, :chao)
  end

  def show_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = x + (25 * i)
      azulejo.asset.y = y
      azulejo.asset.draw
    end
  end
end
