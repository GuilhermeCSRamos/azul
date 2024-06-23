# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL

require_relative 'jogador'
require_relative 'saco'
require_relative 'azulejo'
require_relative 'loja'
require_relative 'jogo'
require_relative 'menu'
require_relative 'wrappers/mouse_wrapper'

$option = 0
$players = 2
$caixa = []

Menu.new.show if $option == 0

Jogo.new.show if $option == 1
