# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL

require_relative 'jogador'
require_relative 'saco'
require_relative 'azulejo'
require_relative 'loja'

# class Main
# end

class MyGame < GameWindow
  def initialize
    super 1600, 800, false
    self.caption = 'Azul da UFF'
    @saco = Saco.new.call
    @lojas = [
      Loja.new(300, 10, @saco.shift(4)),
      Loja.new(10, 300, @saco.shift(4)),
      Loja.new(130, 600, @saco.shift(4)),
      Loja.new(600, 300, @saco.shift(4)),
      Loja.new(460, 600, @saco.shift(4))
    ]
    @chao = Chao.new
    @jogador = ::Jogador.new("tuco", 1)
  end

  def update
    Mouse.update

    if Mouse.button_down? :left

      @lojas.each do |loja|
        # deseleciona azulejos clicados anteriormente
        loja.azulejos.each do |azulejo|
          azulejo.unclicked unless Mouse.x >= 800
        end
        # seleciona azulejos da mesma cor
        loja.azulejos.each do |azulejo|
          if Mouse.x >= azulejo.asset.x && Mouse.x <= azulejo.asset.x + azulejo.width && Mouse.y >= azulejo.asset.y && Mouse.y <= azulejo.asset.y + azulejo.height
            azulejo.clicked(loja)
          end
        end
      end

      @lojas.each do |loja|
        @jogador.filas.each do |fila|
          if Mouse.x >= fila.asset.x && Mouse.x <= fila.asset.x + fila.width && Mouse.y >= fila.asset.y && Mouse.y <= fila.asset.y + fila.height
            selected_azulejos = loja.selected.compact
            if selected_azulejos.any?
              # adiciona os azulejos selecionados a fila do jogador
              fila.add_azulejos(selected_azulejos, @jogador)

              azulejos = loja.azulejos - selected_azulejos
              azulejos.each do |azu|
                @chao.azulejos << azu
              end

              # derruba no chao do jogador os azulejos que nao couberem na fila
              fila.drop_azulejos(@jogador)

              loja.azulejos = []
            end
          end
        end
      end
    end
  end

  def needs_cursor?
    true
  end

  def draw_mouse_coordinates
    Gosu::Font.new(20).draw_text("Mouse X: #{Mouse.x}, Mouse Y: #{Mouse.y}", 10, 10, 1, 1, 1, Gosu::Color::WHITE)
  end
  def draw
    clear 0xffabcdef
    @lojas.each do |loja|
      loja.asset.draw
      loja.show_azulejos
    end

    @jogador.draw_filas

    @chao.asset.draw
    @chao.show_azulejos

    @jogador.draw_chao

    draw_mouse_coordinates
  end
end

MyGame.new.show
