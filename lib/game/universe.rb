require "observer"
require "concurrent/timer_task"

# Game of Live universe representation
class Game::Universe

  # Because there cannot be multiple instances of game's universe
  # this class implements Singleton pattern
  include Singleton

  # This class implements Observable pattern what allows notify observers on each change of universe state
  # Observer must implement `update(universe)` method, where `universe` attribute is updated universe state
  # To subscribe on changes Game::Universe.instance.add_observer(observer) can be called
  include Observable

  attr_reader :grid

  def initialize
    reset
  end

  # Resets universe to initial state
  def reset
    @grid = empty_grid
  end

  # Start evolving universe every time interval specified in `Game.confg.update_interval` property
  def start
    @ticker = Concurrent::TimerTask.new(execution_interval: Game.config.update_interval) { evolve }
    @ticker.execute
  end

  # Stop evolving universe
  def stop
    @ticker.shutdown
    @ticker = nil
  end

  # Evolve universe once and notify observers
  def evolve
    new_grid = empty_grid

    for cell_y in 0..height - 1 do
      for cell_x in 0..width - 1 do
        new_grid[cell_y][cell_x] = evolved_cell_state(cell_x, cell_y)
      end
    end

    @grid = new_grid

    updated
  end

  # New cell state after evolution
  def evolved_cell_state(cell_x, cell_y)
    current_state = grid[cell_y][cell_x]
    neighbours_count, dominant_color = cell_neighbours(cell_x, cell_y)

    if !current_state && neighbours_count == 3
      dominant_color
    elsif neighbours_count < 2 || neighbours_count > 3
      nil
    else
      current_state
    end
  end

  # Find given cell's neighbours count and dominant color
  def cell_neighbours(cell_x, cell_y)
    result = {}

    for curr_x in neighbours_boundries(cell_x, width)
      for curr_y in neighbours_boundries(cell_y, height)
        next if cell_x == curr_x && cell_y == curr_y

        cell_value = grid[curr_y][curr_x]
        if cell_value
          result[cell_value] ||= 0
          result[cell_value] += 1
        end
      end
    end

    neighbours_count = result.values.reduce(&:+) || 0
    dominant_color = result.max_by{ |_, count| count }.first unless result.empty?

    [neighbours_count, dominant_color]
  end

  # Find range restrictions of cell's neighbours in given dimension
  def neighbours_boundries(cell_cords, dimension)
    [0, cell_cords - 1].max..[cell_cords + 1, dimension - 1].min
  end

  # Adds shape to the universe on given coordinates.
  # Coordinates should point to the left top corner of the shape on the grid
  def add_shape(shape, color, cell_x, cell_y)
    for shape_x in 0..shape.width - 1
      for shape_y in 0..shape.height - 1
        x_offset = shape_x + cell_x
        y_offset = shape_y + cell_y
        grid[y_offset][x_offset] = color if shape.pattern[shape_y][shape_x] == 1
      end
    end

    updated
  end

  # Randomly places given shape on the grid
  def throw_shape(shape, color)
    add_shape(shape, color, rand(width - shape.width), rand(height - shape.height))
  end

  # Universe grid's width
  def width
    Game.config.grid_width
  end

  # Universe grid's height
  def height
    Game.config.grid_height
  end

  private

  def empty_grid
    Array.new(height) { Array.new(width) }
  end

  def updated
    changed
    notify_observers(grid)
    grid
  end

end
