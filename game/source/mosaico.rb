# frozen_string_literal: true

class Mosaico
  attr_accessor :x, :y, :asset, :width, :height, :azulejos

  def initialize(x, y)
    @azulejos = [[], [], [], [], []]
    @asset = Sprite.new(x, y, :mosaico)
    @x = asset.x
    @y = asset.y
    @width = asset.img.first.width
    @height = asset.img.first.height
    @mosaico = mosaico_hash
  end

  def mosaico_hash
    [
      {azul: [false, 0, 0], amarelo: [false, 0, 1], vermelho: [false, 0, 2], preto: [false, 0, 3], branco: [false, 0, 4]},
      {branco: [false, 1, 0], azul: [false, 1, 1], amarelo: [false, 1, 2], vermelho: [false, 1, 3], preto: [false, 1, 4]},
      {preto: [false, 2, 0], branco: [false, 2, 1], azul: [false, 2, 2], amarelo: [false, 2, 3], vermelho: [false, 2, 4]},
      {vermelho: [false, 3, 0], preto: [false, 3, 1], branco: [false, 3, 2], azul: [false, 3, 3], amarelo: [false, 3, 4]},
      {amarelo: [false, 4, 0], vermelho: [false, 4, 1], preto: [false, 4, 2], branco: [false, 4, 3], azul: [false, 4, 4]}
    ]
  end

  def montagem(player)
    player.filas.each_with_index do |ea, i|
      if ea.azulejos.size == ea.number
        azulejos[i] << ea.azulejos.shift(1)
        azulejos[i].flatten!
        $caixa << ea.azulejos.shift(5)
        $caixa.flatten!
      end
    end

    position_azulejos
  end

  def position_azulejos
    azulejos.each_with_index do |azulejs, i|
      azulejs.each_with_index do |azulejo, j|
        azulejo.asset.x = asset.x + (25 * mosaico_hash[i][azulejo.color.to_sym][2])
        azulejo.asset.y = asset.y + (25 * mosaico_hash[i][azulejo.color.to_sym][1])
      end
    end
  end

  def show_azulejos
    azulejos.flatten.map.with_index do |azulejo, i|
      azulejo.asset.draw
    end
  end

  def rectangle
    Rectangle.new(asset.x, asset.y, width, height)
  end
end
