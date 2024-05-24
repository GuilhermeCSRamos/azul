# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL

# class Main
# end

class MyGame < GameWindow
  def initialize
    super 1600, 800, false
    self.caption = 'Meu Primeiro Jogo'
    @saco = Saco.new.call
    @lojas = [
      Loja.new(300, 10, @saco.shift(4)),
      Loja.new(10, 300, @saco.shift(4)),
      Loja.new(130, 600, @saco.shift(4)),
      Loja.new(600, 300, @saco.shift(4)),
      Loja.new(460, 600, @saco.shift(4))
    ]
    # binding.pry

    # @img = Res.img :tabuleiro
    # # @sprite = Sprite.new(0, 0, :megaman, 5, 2)
    # @sprite = GameObject.new(10, 10, 170, 180, :megaman, Vector.new(0, 0), 5, 2)
    # @x = @y = 0
    # @walls = [
    #   Block.new(0, 0, 10, 600),
    #   Block.new(0, 0, 800, 10),
    #   Block.new(790, 0, 10, 600),
    #   Block.new(0, 590, 800, 10),
    #   Block.new(250, 0, 10, 400),
    #   Block.new(550, 200, 10, 400)
    # ]
  end

  def update
    # KB.update
    #
    # v = Vector.new(0, 0)
    # v.x += 3 if KB.key_down?(Gosu::KB_RIGHT)
    # v.x -= 3 if KB.key_down?(Gosu::KB_LEFT)
    # v.y += 3 if KB.key_down?(Gosu::KB_DOWN)
    # v.y -= 3 if KB.key_down?(Gosu::KB_UP)
    #
    # @sprite.move(v, @walls, [], true)
    # @sprite.animate([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20)
  end

  def needs_cursor?
    true
  end

  def draw
    clear 0xffabcdef
    @lojas.each do |loj|
      loj.asset.draw
      loj.show_azulejos
    end


    
    # @img.draw @x, @y, 0
    # # binding.pry
    # @sprite.draw
    # @walls.each do |w|
    #   draw_quad(w.x, w.y, 0xff000000,
    #             w.x + w.w, w.y, 0xff000000,
    #             w.x, w.y + w.h, 0xff000000,
    #             w.x + w.w, w.y + w.h, 0xff000000, 0)
    # end
  end
end

class Loja
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :slots

  def initialize(x, y, azulejos)
    @slots = [[1, 2], [3, 4]]
    @x = x
    @y = y
    @width = 120
    @height = 120
    @azulejos = azulejos
    @asset = Sprite.new(x, y, :fabrica)
    # create_azulejos
    # show_azulejos
  end

  def show_azulejos
    azulejos.each_slice(2).with_index do |azulejo, i|
      azulejo[0].asset.x = (x + 25)
      azulejo[0].asset.y = (y + 25) + (50 * i)
      azulejo[1].asset.x = (x + 70)
      azulejo[1].asset.y = (y + 25) + (50 * i)

      azulejo.each { |azu| azu.asset.draw }
    end
  end

  def create_azulejos
    jump_row = 0
    slots.map do |row|
      jump_row += 1
      row.map do |slot|
        _x = x + 30 * slot
        _y = y + 30 * jump_row
        Azulejo.new(_x, _y, "azul")
      end
    end.flatten
  end
end

class Azulejo
  attr_accessor :asset, :width, :height, :color

  def initialize(x, y, color)
    @color = color
    @width = 25
    @height = 25
    @asset = Sprite.new(x, y, asset_name)
  end

  def asset_name
    string = "azulejo_" + color
    string.to_sym
  end
end

class Saco
  def initialize
    @colors = ["azul", "amarelo", "branco", "preto", "vermelho"]
    @azulejos = create_azulejos
  end

  def call
    create_azulejos
  end

  def create_azulejos
    (1..20).map do |azulejo|
      @colors.map do |color|
        Azulejo.new(-100, -100, color)
      end
    end.flatten.shuffle
  end
end

MyGame.new.show
