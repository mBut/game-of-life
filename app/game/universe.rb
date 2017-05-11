require "observer"

class Game::Universe
  include Observable
  include Singleton

  attr_reader :rows, :cols, :grid

  def reset!
    @grid = empty_grid
  end

  def start
    reset!
  end

  def evolve
    new_grid = empty_grid

    for i in 0..rows - 1 do
      for j in 0..cols - 1 do
        cell = grid[i][j]
        n = cell_neighbours_count(i, j)

        if cell.zero?
          new_grid[i][j] = 1 if n == 3
        elsif n < 2 || n > 3
          new_grid[i][j] = 0
        else
          new_grid[i][j] = cell
        end
      end
    end

    @grid = new_grid

    changed
    notify_observers(new_grid)
  end

  def add_shape(mask, x0, y0)
    for i in 0..mask.size - 1 do
      for j in 0..mask.size - 1 do
        grid[i + y0][j + x0] = mask[i][j]
      end
    end

    changed
    notify_observers(grid)
  end

  private

  def empty_grid
    @rows, @cols = Game.config.grid_size
    Array.new(cols) { Array.new(rows, 0) }
  end

  def cell_neighbours_count(i, j)
    n = 0
    for x in [0, i - 1].max..[i + 1, rows - 1].min
      for y in [0, j - 1].max..[j + 1, cols - 1].min
        next if i == x && j == y
        n += 1 unless grid[x][y].zero?
      end
    end
    n
  end

end
