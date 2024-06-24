# frozen_string_literal: true

class Chao
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :number

  def initialize
    @azulejos = [Azulejo.new(180, 180, "token")]
    @x = 180
    @y = 180
    @width = 126
    @height = 25
    @asset = Sprite.new(x, y, :chao)
  end

  def position_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = x + (25 * i)
      azulejo.asset.y = y
    end
  end

  def show_azulejos
    azulejos.map.with_index do |azulejo, i|
      binding.pry if azulejo.nil?
      azulejo.asset.draw
      azulejo.highlight_clicked.draw if azulejo.clicked?
    end
  end

  def selected
    azulejos.map do |azulejo|
      azulejo if azulejo.clicked?
    end
  end

  def rectangle
    Rectangle.new(asset.x, asset.y, width, height)
  end
end
