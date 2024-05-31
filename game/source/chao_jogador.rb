# frozen_string_literal: true

require_relative 'chao'

class ChaoJogador < Chao
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :number

  def initialize(x, y)
    @azulejos = []
    @x = x
    @y = y
    @width = 176
    @height = 30
    @asset = Sprite.new(x, y, :chaojogador)
  end

  def show_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = x + (25 * i)
      azulejo.asset.y = y + 5
      azulejo.asset.draw
    end
  end
end
