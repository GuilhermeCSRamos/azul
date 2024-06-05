# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL

require_relative 'jogador'
require_relative 'saco'
require_relative 'azulejo'
require_relative 'loja'
require_relative 'wrappers/mouse_wrapper'

class Main < GameWindow
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

    @last_time = Gosu.milliseconds
    @frame_count = 0
    @fps = 0
  end

  def update
    Mouse.update
    mouse_wrapper = MouseWrapper.new(Mouse)
    if Mouse.x <= 800
      @disposal_azulejos = @lojas.map { |loja| loja.azulejos }.flatten
      @hovered_loja = mouse_wrapper.over_any?(@lojas)
    end

    if Mouse.button_down? :left
      # deseleciona azulejos clicados anteriormente
      @disposal_azulejos.each do |azulejo|
        azulejo.unclicked unless Mouse.x >= 800
      end

      # seleciona azulejos da mesma cor
      if @hovered_loja
        @hovered_loja.azulejos.each do |azulejo|
          if Mouse.over? azulejo.rectangle
            azulejo.clicked(@hovered_loja)
            @clicked_loja = @hovered_loja
          end
        end
      end

      if Mouse.x >= 800
        @hovered_fila = mouse_wrapper.over_any?(@jogador.filas)

        if @hovered_fila
          selected_azulejos = @clicked_loja.selected.compact

          if selected_azulejos.any?

            # adiciona os azulejos selecionados a fila do jogador
            @hovered_fila.add_azulejos(selected_azulejos, @jogador)

            azulejos = @clicked_loja.azulejos - selected_azulejos
            azulejos.each do |azu|
              @chao.azulejos << azu
            end

            # derruba no chao do jogador os azulejos que nao couberem na fila
            @hovered_fila.drop_azulejos(@jogador)

            @clicked_loja.azulejos = []
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

  def draw_fps
    if (Gosu.milliseconds - @last_time) >= 1000
      @fps = @frame_count * 1000 / (Gosu.milliseconds - @last_time)
      @frame_count = 0
      @last_time = Gosu.milliseconds
    end
    @frame_count += 1
    Gosu::Font.new(20).draw_text("FPS: #{@fps}", 10, 50, 1, 1, 1, Gosu::Color::WHITE)
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
    draw_fps
  end
end

Main.new.show
