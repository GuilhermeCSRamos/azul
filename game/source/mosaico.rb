# frozen_string_literal: true

class Mosaico
  attr_accessor :x, :y, :asset, :width, :height, :azulejos

  def initialize(x, y)
    @azulejos = []
    @asset = Sprite.new(x, y, :mosaico)
    @x = asset.x
    @y = asset.y
    @width = asset.img.first.width
    @height = asset.img.first.height
    @mosaico = mosaico_hash
  end

  def mosaico_hash
    [
      [
        { azul: false }, { amarelo: false }, { vermelho: false }, { preto: false }, { branco: false }
      ],
      [
        { branco: false }, { azul: false }, { amarelo: false }, { vermelho: false }, { preto: false }
      ],
      [
        { preto: false }, { branco: false }, { azul: false }, { amarelo: false }, { vermelho: false }
      ],
      [
        { vermelho: false }, { preto: false }, { branco: false }, { azul: false }, { amarelo: false }
      ],
      [
        { amarelo: false }, { vermelho: false }, { preto: false }, { branco: false }, { azul: false }
      ]
    ]
  end

  def rectangle
    Rectangle.new(asset.x, asset.y, width, height)
  end
end
