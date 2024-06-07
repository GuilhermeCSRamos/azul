# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL

require_relative 'jogador'
require_relative 'saco'
require_relative 'azulejo'
require_relative 'loja'
require_relative 'wrappers/mouse_wrapper'

class Menu < GameWindow
  def initialize
    super 1600, 800, false
    self.caption = 'Azul da UFF'

    @play = Sprite.new(600, 180, :botao_play)
    @sair = Sprite.new(600, 280, :botao_sair)
    @um = Sprite.new(600, 150, :botao_um)
    @dois = Sprite.new(650, 150, :botao_dois)
    @tres = Sprite.new(700, 150, :botao_tres)
  end

  def update
    Mouse.update
    mouse_wrapper = MouseWrapper.new(Mouse)

    if mouse_wrapper.mouse_clicked?(rectangle(@play)) && $players.positive?
      $option = 1
      self.close
    end

    if mouse_wrapper.mouse_clicked?(rectangle(@sair))
      exit
    end

    if mouse_wrapper.mouse_clicked?(rectangle(@um))
      $players = 1
    end

    if mouse_wrapper.mouse_clicked?(rectangle(@dois))
      $players = 2
    end
  end

  def needs_cursor?
    true
  end

  def draw
    clear 0xffabcdef

    @play.draw
    @sair.draw
    @um.draw
    @dois.draw
    @tres.draw
  end

  def rectangle(asset)
    Rectangle.new(asset.x, asset.y, asset.img.first.width, asset.img.first.height)
  end
end
