# frozen_string_literal: true

class Loja
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :slots

  def initialize(x, y, azulejos)
    @slots = [[1, 2], [3, 4]]
    @asset = Sprite.new(x, y, :fabrica)
    @x = asset.x
    @y = asset.y
    @width = asset.img.first.width
    @height = asset.img.first.height
    @azulejos = azulejos
    position_azulejo
  end

  def position_azulejo
    azulejos.each_slice(2).with_index do |azulejo, i|
      azulejo[0].asset.x = (x + 25)
      azulejo[0].asset.y = (y + 25) + (50 * i)
      azulejo[1].asset.x = (x + 70)
      azulejo[1].asset.y = (y + 25) + (50 * i)
    end
  end

  def show_azulejos
    azulejos.each do |azu|
      azu.asset.draw
      azu.highlight_clicked.draw if azu.clicked?
    end
  end

  def create_azulejos
    jump_row = 0
    slots.map do |row|
      jump_row += 1
      row.map do |slot|
        _x = x + 30 * slot
        _y = y + 30 * jump_row
        Azulejo.new(_x, _y, "azul")
      end
    end.flatten
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
