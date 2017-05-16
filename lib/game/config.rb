# Game configuration helper
class Game::Config
  # Configuration properties:
  # :update_interval - time interval in seconds how often game universe must be updated (default - 1s)
  # :canvas_size - game size in browser as array in format [width, height] (default - [200, 200])
  # :pixel_size - size of cell in pixels in the game. :canvas_size dimensions must be evenly devisible on the provided value (default - 10)
  # :shapes_dir - directory with shapes patterns presets. Shapes must be defined as plain text files where "x" represnets alive cell and "o" - dead cell.
  #   Example:
  #   o x o
  #   o x o
  #   o x o

  DEFAULT_SHAPES_DIR = File.expand_path("~").freeze
  DEFAULT_CANVAS_SIZE = [200, 200].freeze
  DEFAULT_PIXEL_SIZE = 10.freeze
  DEFAULT_UPDATE_INTERVAL = 1.freeze
  DEFAULT_MAX_PLAYERS_COUNT = 20.freeze

  attr_accessor :update_interval
  attr_reader :shapes_dir, :canvas_width, :canvas_height, :pixel_size

  def initialize
    self.shapes_dir = DEFAULT_SHAPES_DIR
    self.canvas_size = DEFAULT_CANVAS_SIZE
    self.pixel_size = DEFAULT_PIXEL_SIZE
    self.update_interval = DEFAULT_UPDATE_INTERVAL
  end

  def shapes_dir=(path)
    @shapes_dir = File.expand_path(path)
  end

  def canvas_size=(value)
    validate_dimension_restrictions(value[0], value[1], @pixel_size)
    @canvas_width, @canvas_height = value
  end

  def pixel_size=(value)
    validate_dimension_restrictions(@canvas_height, @canvas_size, value)
    @pixel_size = value
  end

  def grid_width
    canvas_width / pixel_size
  end

  def grid_height
    canvas_height / pixel_size
  end

  private

  def validate_dimension_restrictions(width, height, pixel_size)
    return true unless width && height && pixel_size

    if width % pixel_size != 0 || height % pixel_size != 0
      raise Game::ConfigurationError, "canvas_width and canvas_height must be devisible on pixel_size without reminder"
    end

    true
  end

end
