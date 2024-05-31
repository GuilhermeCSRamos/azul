# frozen_string_literal: true

class Fila
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :number

  def initialize(x, y, number)
    @number = number
    @actual_color = ""
    @azulejos = []
    @x = x
    @y = y
    @width = 126
    @height = 25
    @asset = Sprite.new(x, y, :fila)
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
  end

  def show_azulejos
    azulejos.map.with_index do |azulejo, i|
      azulejo.asset.x = x + (25 * i)
      azulejo.asset.y = y
      azulejo.asset.draw
    end
  end

  def drop_azulejos(jogador)
    if azulejos.size > number
      azulejos.pop(azulejos.size - number).each do |azu|
        jogador.chao_jogador.azulejos << azu
      end
    end
  end
end
