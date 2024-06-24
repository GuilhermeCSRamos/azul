# frozen_string_literal: true

require_relative 'chao'

class ChaoJogador < Chao
  attr_accessor :x, :y, :asset, :width, :height, :azulejos

  def initialize(x, y)
    @azulejos = []
    @x = x
    @y = y
    @width = 176
    @height = 30
    @asset = Sprite.new(x, y, :chaojogador)
    @score_map = [0, 1, 2, 4, 6, 8, 11, 14]
  end

  def position_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = asset.x + (25 * i)
      azulejo.asset.y = asset.y + 5
    end
  end

  def show_azulejos
    azulejos.map do |azulejo|
      azulejo.asset.draw
    end
  end

  def score
    @score_map[azulejos.size]
  end
end
