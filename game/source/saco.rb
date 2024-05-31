# frozen_string_literal: true

class Saco
  def initialize
    @colors = %w[azul amarelo branco preto vermelho] # semantica diferente para array de string
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

