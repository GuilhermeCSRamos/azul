# frozen_string_literal: true

require 'pry'
require 'minigl'
include MiniGL

module Helper
  def position_assets(collection, start_x = 1, start_y = 1, spacing = 10, assets_per_row = 10)
    @collection = collection
    current_x = start_x
    current_y = start_y
    row_count = 0
    @assets_per_row = assets_per_row
    @spacing = spacing
    @start_x = current_x
    @start_y = current_y

    @collection.each_with_index do |asset, index|
      if index > 0 && index % @assets_per_row == 0
        row_count += 1
        current_x = @start_x
        current_y = @start_y + (asset.height + @spacing) * row_count
      end

      asset.asset.x = current_x
      asset.asset.y = current_y
      current_x += asset.width + @spacing
    end
  end

  def position_boards(collection, start_x = 1, start_y = 1, spacing = 10, assets_per_row = 10)
    @collection = collection
    current_x = start_x
    current_y = start_y
    row_count = 0
    @assets_per_row = assets_per_row
    @spacing = spacing
    @start_x = current_x
    @start_y = current_y

    @collection.each_with_index do |asset, index|
      if index > 0 && index % @assets_per_row == 0
        row_count += 1
        current_x = @start_x

        current_y = @start_y + (asset[:filas].reduce { |b, a| a.height } + @spacing) * row_count
      end

      asset[:filas].each_with_index do |each, i|
        each.asset.x = current_x
        each.asset.y = current_y + (25 * i)
      end

      asset[:mosaico].asset.x = 2 + current_x + asset[:filas].first.width
      asset[:mosaico].asset.y = current_y

      asset[:chao_jogador].asset.x = current_x
      asset[:chao_jogador].asset.y = 35 + current_y + 100

      current_x += (asset[:filas].reduce { |b, a| a.width } + @spacing)
    end
  end
end
