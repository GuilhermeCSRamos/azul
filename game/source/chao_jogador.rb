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

  def position_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = asset.x + (25 * i)
      azulejo.asset.y = asset.y + 5
    end
  end

  def show_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.draw
    end
  end
end
