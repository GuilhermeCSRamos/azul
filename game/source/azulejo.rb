# frozen_string_literal: true

class Azulejo
  attr_accessor :x, :y, :asset, :width, :height, :color, :clicked

  def initialize(x, y, color)
    @clicked = false
    @color = color
    @asset = Sprite.new(x, y, asset_name(color))
    @x = asset.x
    @y = asset.y
    @width = asset.img.first.width
    @height = asset.img.first.height
  end

  def asset_name(type)
    string = "azulejo_" + type
    string.to_sym
  end

  def clicked(loja = nil)
    @clicked = true
    loja.azulejos.each do |azu|
      azu.clicked if azu.color == @color
    end if loja
  end

  def unclicked
    @clicked = false
  end
  def clicked?
    @clicked
  end

  def highlight_clicked
    if clicked?
      Sprite.new(asset.x, asset.y, asset_name("clicked"))
    end
  end

  def rectangle
    Rectangle.new(asset.x, asset.y, width, height)
  end
end
