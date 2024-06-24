# frozen_string_literal: true

class Mosaico
  attr_accessor :x, :y, :asset, :width, :height, :azulejos, :azulejos_matrix

  def initialize(x, y)
    @azulejos = [[], [], [], [], []]
    @azulejos_matrix = [
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false]
    ]
    @asset = Sprite.new(x, y, :mosaico)
    @x = asset.x
    @y = asset.y
    @width = asset.img.first.width
    @height = asset.img.first.height
    @mosaico = mosaico_hash
    @score = 0
  end

  def mosaico_hash
    [
      {azul: [0, 0], amarelo: [0, 1], vermelho: [0, 2], preto: [0, 3], branco: [0, 4]},
      {branco: [1, 0], azul: [1, 1], amarelo: [1, 2], vermelho: [1, 3], preto: [1, 4]},
      {preto: [2, 0], branco: [2, 1], azul: [2, 2], amarelo: [2, 3], vermelho: [2, 4]},
      {vermelho: [3, 0], preto: [3, 1], branco: [3, 2], azul: [3, 3], amarelo: [3, 4]},
      {amarelo: [4, 0], vermelho: [4, 1], preto: [4, 2], branco: [4, 3], azul: [4, 4]}
    ]
  end

  def montagem(player)
    player.filas.each_with_index do |ea, i|
      if ea.azulejos.size == ea.number
        azulejos[i] << ea.azulejos.shift(1)
        azulejos[i].flatten!
        $caixa << ea.azulejos.shift(5)
        $caixa.flatten!
      end
    end

    position_azulejos
  end

  def position_azulejos
    azulejos.each_with_index do |azulejs, i|
      azulejs.each_with_index do |azulejo, j|
        azulejo.asset.x = asset.x + (25 * mosaico_hash[i][azulejo.color.to_sym][1])
        azulejo.asset.y = asset.y + (25 * mosaico_hash[i][azulejo.color.to_sym][0])

        azulejos_matrix[mosaico_hash[i][azulejo.color.to_sym][0]][mosaico_hash[i][azulejo.color.to_sym][1]] = true
      end
    end
  end

  def score
    mosaico = azulejos_matrix
    tamanho = mosaico.size
    pontuacao = 0

    # Pontuação por azulejos colocados
    (0...tamanho).each do |i|
      (0...tamanho).each do |j|
        next unless mosaico[i][j] # Continue se não houver azulejo aqui

        # Pontua o azulejo atual
        pontuacao += 1

        # Pontuação horizontal
        horizontal = 1
        k = j - 1
        while k >= 0 && mosaico[i][k]
          horizontal += 1
          k -= 1
        end
        k = j + 1
        while k < tamanho && mosaico[i][k]
          horizontal += 1
          k += 1
        end

        # Pontuação vertical
        vertical = 1
        k = i - 1
        while k >= 0 && mosaico[k][j]
          vertical += 1
          k -= 1
        end
        k = i + 1
        while k < tamanho && mosaico[k][j]
          vertical += 1
          k += 1
        end

        # Adiciona a pontuação maior entre horizontal e vertical (evita contar duplamente)
        pontuacao += [horizontal, vertical].max - 1
      end
    end

    # Pontuação por linhas completas
    pontuacao += 2 * mosaico.count { |linha| linha.all? }

    # Pontuação por colunas completas
    (0...tamanho).each do |j|
      completa = true
      (0...tamanho).each do |i|
        unless mosaico[i][j]
          completa = false
          break
        end
      end
      pontuacao += 7 if completa
    end

    # Pontuação por todas as cores (assumindo que as cores são representadas em diferentes arrays booleanos)
    cores_completas = Hash.new(0)
    mosaico.each do |linha|
      linha.each do |tile|
        cores_completas[tile] += 1 if tile
      end
    end
    cores_completas.each_value do |contagem|
      pontuacao += 10 if contagem == 5
    end

    pontuacao
  end

  def show_azulejos
    azulejos.flatten.map.with_index do |azulejo, i|
      azulejo.asset.draw
    end
  end

  def rectangle
    Rectangle.new(asset.x, asset.y, width, height)
  end
end
