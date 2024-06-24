# frozen_string_literal: true

require_relative 'chao_jogador'
require_relative 'fila'
require_relative 'mosaico'
require_relative 'helper/position_helper'
include Helper

class Jogador
  attr_accessor :filas, :chao_jogador, :mosaico, :number, :score
  def initialize(nome, number)
    @nome = nome
    @number = number
    @filas = [
      Fila.new(800, 200, 1),
      Fila.new(800, 225, 2),
      Fila.new(800, 250, 3),
      Fila.new(800, 275, 4),
      Fila.new(800, 300, 5)
    ]
    @mosaico = Mosaico.new(1000, 200)
    @chao_jogador = ChaoJogador.new(800, 350)
    @score = 0
  end

  def draw_filas
    @filas.each do |fila|
      fila.asset.draw
      fila.show_azulejos
    end
  end

  def draw_chao
    @chao_jogador.asset.draw
    @chao_jogador.show_azulejos
  end

  def draw_mosaico
    @mosaico.asset.draw
    @mosaico.show_azulejos
  end

  def draw_score(x = chao_jogador.asset.x + chao_jogador.width + 5, y = chao_jogador.asset.y)
    Gosu::Font.new(20).draw_text("Pontos: #{@score}", x, y, 1, 1, 1, Gosu::Color::WHITE)
  end
end
