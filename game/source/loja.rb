# frozen_string_literal: true

class Loja
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :slots

  def initialize(x, y, azulejos)
    @slots = [[1, 2], [3, 4]]
    @x = x
    @y = y
    @width = 120
    @height = 120
    @azulejos = azulejos
    @asset = Sprite.new(x, y, :fabrica)
  end

  def show_azulejos
    azulejos.each_slice(2).with_index do |azulejo, i|
      azulejo[0].asset.x = (x + 25)
      azulejo[0].asset.y = (y + 25) + (50 * i)
      azulejo[1].asset.x = (x + 70)
      azulejo[1].asset.y = (y + 25) + (50 * i)

      azulejo.each do |azu|
        azu.asset.draw
        azu.highlight_clicked.draw if azu.clicked?
      end
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
end
