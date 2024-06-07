# frozen_string_literal: true

require_relative 'chao_jogador'
require_relative 'fila'
require_relative 'mosaico'
require_relative 'helper/position_helper'
include Helper

class Jogador
  attr_accessor :filas, :chao_jogador, :mosaico, :number
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
  end
end
