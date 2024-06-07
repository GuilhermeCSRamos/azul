# frozen_string_literal: true

class Fila
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :number

  def initialize(x, y, number)
    @number = number
    @actual_color = ""
    @azulejos = []
    @asset = Sprite.new(x, y, asset_name(number))
    @x = asset.x
    @y = asset.y
    @width = asset.img.first.width
    @height = asset.img.first.height
  end

  def asset_name(type)
    string = "fila" + type.to_s
    string.to_sym
  end

  def add_azulejos(selected_azulejos, jogador)
    if @azulejos.empty?
      # se a fila estiver vazia, deve acrescentar os azulejos e definir a cor atual da fila
      @azulejos = selected_azulejos
      @actual_color = selected_azulejos.first.color

    elsif @actual_color == selected_azulejos.first.color
      # se a fila já tiver azulejos da mesma cor, acrescentar
      selected_azulejos.each do |azulejo|
        @azulejos << azulejo
      end

    else
      # se a fila tiver azulejos de cor diferente, substituir e descartar os antigos no chão do jogador
      @azulejos.each do |azulejo|
        jogador.chao_jogador.azulejos << azulejo
      end

      @azulejos = selected_azulejos
      @actual_color = selected_azulejos.first.color
    end

    position_azulejos
  end

  def position_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = asset.x + (25 * i)
      azulejo.asset.y = asset.y
    end
  end
  def show_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.draw
    end
  end

  def drop_azulejos(jogador)
    if azulejos.size > number
      azulejos.pop(azulejos.size - number).each do |azu|
        jogador.chao_jogador.azulejos << azu
      end
      jogador.chao_jogador.position_azulejos
    end
  end

  def rectangle
    Rectangle.new(asset.x, asset.y, width, height)
  end
end
