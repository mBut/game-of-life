require "observer"

class Game::Universe
  include Observable
  include Singleton

  attr_reader :rows, :cols, :grid, :players

  def self.start!
    ticker = Concurrent::TimerTask.new(execution_interval: Game.config.interval) do
      self.instance.evolve
    end

    at_exit { ticker.shutdown }

    ticker.execute
  end

  def initialize
    @grid = empty_grid
    @players = {}
  end

  def evolve
    new_grid = empty_grid

    for i in 0..rows - 1 do
      for j in 0..cols - 1 do
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

    for x in [0, i - 1].max..[i + 1, rows - 1].min
      for y in [0, j - 1].max..[j + 1, cols - 1].min
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

  def add_player(player_id, client)
    @players[player_id] ||= Game::Color.random.as_hex
    add_observer(client)
  end

  def add_shape_by_mask(player_id, mask, x0, y0)
    cell_color = players[player_id]

    for i in 0..mask.size - 1 do
      for j in 0..mask.size - 1 do
        grid[i + y0][j + x0] = cell_color if mask[i][j] == 1
      end
    end

    changed
    notify_observers(grid)
  end

  private

  def empty_grid
    @rows, @cols = Game.config.grid_size
    Array.new(cols) { Array.new(rows) }
  end

end
