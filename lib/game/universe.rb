require "observer"

class Game::Universe
  include Observable
  include Singleton

  attr_reader :width, :height, :grid

  def self.start!
    ticker = Concurrent::TimerTask.new(execution_interval: Game.config.interval) do
      self.instance.evolve
    end

    at_exit { ticker.shutdown }

    ticker.execute
  end

  def initialize
    @width, @height = Game.config.size.map{ |x| x / Game.config.pixel_size }
    @grid = empty_grid
  end

  def evolve
    new_grid = empty_grid

    for i in 0..height - 1 do
      for j in 0..width - 1 do
        cell = grid[i][j]

        n, dominant_color = cell_neighbours(i, j)

        if cell.nil?
          new_grid[i][j] = dominant_color if n == 3
        elsif n < 2 || n > 3
          new_grid[i][j] = nil
        else
          new_grid[i][j] = cell
        end
      end
    end

    changed
    notify_observers(new_grid)

    @grid = new_grid
  end

  def cell_neighbours(i, j)
    result = {}

    for x in [0, i - 1].max..[i + 1, height - 1].min
      for y in [0, j - 1].max..[j + 1, width - 1].min
        next if i == x && j == y

        cell = grid[x][y]
        unless cell.nil?
          result[cell] ||= 0
          result[cell] += 1
        end
      end
    end

    n = result.values.reduce(&:+) || 0
    dominant_color = result.max_by{ |_, v| v }.first unless result.empty?

    [n, dominant_color]
  end

  def add_shape(mask, color, x0, y0)
    mask.each_with_index do |row, i|
      row.each_with_index do |bit, j|
        grid[i + y0][j + x0] = color unless bit.zero?
      end
    end

    changed
    notify_observers(grid)
  end

  def throw_shape(mask, color)
    n = mask.size
    add_shape(mask, color, rand(width - n), rand(height - n))
  end

  private

  def empty_grid
    Array.new(height) { Array.new(width) }
  end

end
