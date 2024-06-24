# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL
include Helper

require_relative 'jogador'
require_relative 'saco'
require_relative 'azulejo'
require_relative 'loja'
require_relative 'wrappers/mouse_wrapper'

class Jogo < GameWindow
  attr_accessor :state

  def initialize
    super 1600, 800, false
    self.caption = 'Azul da UFF'

    # :menu, :store, :queue, :mosaic, :score, :restart, :end_game
    @state = :store
    @saco = Saco.new.call
    @lojas = [
      Loja.new(300, 10, @saco.shift(4)),
      Loja.new(10, 300, @saco.shift(4)),
      Loja.new(130, 600, @saco.shift(4)),
      Loja.new(600, 300, @saco.shift(4)),
      Loja.new(460, 600, @saco.shift(4))
    ]

    @lojas << [Loja.new(60, 90, @saco.shift(4)),
               Loja.new(550, 90, @saco.shift(4))] if $players >= 3
    @lojas << [Loja.new(30, 500, @saco.shift(4)),
               Loja.new(580, 500, @saco.shift(4))] if $players >= 4

    @lojas.flatten!

    @chao = Chao.new
    @selected_azulejos = []
    @clicked_loja = nil
    @hovered_fila = nil
    @clicked_chao = nil
    @jogadores = (1..$players).map { |n| ::Jogador.new("tuco" + n.to_s, n) }
    @jogador = @jogadores.first

    @last_time = Gosu.milliseconds
    @frame_count = 0
    @fps = 0

    players_position_boards
  end

  def update
    Mouse.update
    mouse_wrapper = MouseWrapper.new(Mouse)

    if state == :store
      @disposal_azulejos = @lojas.map { |loja| loja.azulejos }.flatten
      @all_azulejos = [@disposal_azulejos + @chao.azulejos].flatten
      @hovered_loja = mouse_wrapper.over_any?(@lojas)
      @hovered_fila = mouse_wrapper.over_any?(@jogador.filas)
      @hovered_chao = @chao if Mouse.over?(@chao.rectangle)

      if @disposal_azulejos.size.zero? && @chao.azulejos.size.zero?
        @state = :mosaic
      end

      if Mouse.button_pressed? :left
        if @hovered_fila && (@clicked_loja || @clicked_chao)
          @state = :queue
        end

        # deseleciona azulejos clicados anteriormente
        @all_azulejos.each do |azulejo|
          azulejo.unclick! unless @hovered_fila
          @clicked_loja = nil unless @hovered_fila
          @clicked_chao = nil unless @hovered_fila
        end

        # seleciona azulejos da mesma cor
        if @hovered_loja
          @hovered_loja.azulejos.each do |azulejo|
            if Mouse.over? azulejo.rectangle
              azulejo.clicked(@hovered_loja)
              @clicked_loja = @hovered_loja
            end
          end
        elsif @hovered_chao
          @chao.azulejos.each do |azulejo|
            if Mouse.over? azulejo.rectangle
              azulejo.clicked(@chao)
              @clicked_chao = @hovered_chao
            end
          end
        end
      end

    elsif state == :queue
      if @hovered_fila

        selected_azulejos = @clicked_loja&.selected&.compact || @chao.selected.compact
        if selected_azulejos.any?
          # adiciona os azulejos selecionados a fila do jogador
          @hovered_fila.add_azulejos(selected_azulejos, @jogador)

          if @clicked_loja
            # derruba os azulejos restantes na loja
            azulejos = @clicked_loja.azulejos - selected_azulejos
            azulejos.each do |azu|
              @chao.azulejos << azu
            end
            @clicked_loja.azulejos = []
          elsif @clicked_chao
            @chao.azulejos = @chao.azulejos - selected_azulejos
          end

          @chao.position_azulejos

          # derruba no chao do jogador os azulejos que nao couberem na fila
          @hovered_fila.drop_azulejos(@jogador)

          next_player
        end
      end
    elsif state == :mosaic
      # montagem do mosaico
      @jogadores.each do |jogador|
        jogador.mosaico.montagem(jogador)
      end

      @state = :score
    elsif state == :score
      @jogadores.each do |jogador|
        #verifica se há vitória
        @state = :end_game if jogador.mosaico.end_game?

        jogador.score = jogador.mosaico.score(state) - jogador.chao_jogador.score
        jogador.score = 0 if jogador.score.negative?
      end

      @state = :restart unless state == :end_game
    elsif state == :restart
      @jogadores.each do |jogador|
        token, jogador.chao_jogador.azulejos = jogador.chao_jogador.azulejos.partition { |ea| ea.color == "token" }
        # jogador com token será o primeiro da prox rodada
        @jogador = jogador if token
        @chao.azulejos << token
        @chao.azulejos.flatten!.compact!

        @chao.position_azulejos
        jogador.chao_jogador.position_azulejos

        $caixa << jogador.chao_jogador.azulejos.shift(jogador.chao_jogador.azulejos.size)
        $caixa.flatten!
      end

      if (@saco.size < 20 && $players == 2) || (@saco.size < 28 && $players == 3) || (@saco.size < 36 && $players == 4)
        @saco << $caixa.shift($caixa.size)
        @saco.flatten!
      end

      @lojas = [
        Loja.new(300, 10, @saco.shift(4)),
        Loja.new(10, 300, @saco.shift(4)),
        Loja.new(130, 600, @saco.shift(4)),
        Loja.new(600, 300, @saco.shift(4)),
        Loja.new(460, 600, @saco.shift(4))
      ]

      @lojas << [Loja.new(60, 90, @saco.shift(4)),
                 Loja.new(550, 90, @saco.shift(4))] if $players >= 3
      @lojas << [Loja.new(30, 500, @saco.shift(4)),
                 Loja.new(580, 500, @saco.shift(4))] if $players >= 4





      # puts "caixa: " + $caixa.size.to_s
      # print $caixa.map(&:color)
      # puts
      # puts "saco: " + @saco.size.to_s
      # puts "chao: "
      # print @chao.azulejos.map(&:color)
      # puts
      # puts "chao jogador 1"
      # print @jogadores.first.chao_jogador.azulejos.map(&:color)
      # puts
      # puts "chao jogador 2"
      # print @jogadores.last.chao_jogador.azulejos.map(&:color)
      # puts


      @state = :store

    elsif state == :end_game
      # binding.pry


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

    @jogadores.map(&:draw_filas)
    @jogadores.map(&:draw_mosaico)
    @jogadores.map(&:draw_chao)
    @jogadores.map(&:draw_score)

    @chao.asset.draw
    @chao.show_azulejos

    # draw_mouse_coordinates
    # draw_fps
  end

  def next_player
    @jogador = @jogadores[@jogador.number] ? @jogadores[@jogador.number] : @jogadores[0]
    @state = :store
  end


  def players_position_boards
    # array = [{ filas: @filas, mosaico: @mosaico, chao_jogador: @chao_jogador }]
    array = @jogadores.map do |jogador|
      {
        filas: jogador.filas,
        mosaico: jogador.mosaico,
        chao_jogador: jogador.chao_jogador
      }
    end
    position_boards(array, 800, 200, 200, 2)
  end
end
