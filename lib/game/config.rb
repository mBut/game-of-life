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

  attr_accessor :update_interval
  attr_reader :shapes_dir, :canvas_width, :canvas_height, :pixel_size

  def initialize
    @canvas_size = [200, 200]
    @pixel_size = 10
    @interval = 1
  end

  def shapes_dir=(path)
    @shapes_dir = File.expand_path(path)
  end

  def canvas_size=(value)
    @canvas_width, @canvas_height = value
    Game.universe.reset
  end

  def pixel_size=(value)
    if @canvas_width % value != 0 || @canvas_height % value != 0
      raise ArgumentError, "canvas_width and canvas_height must be devisible on pixel_size without reminder"
    end

    @pixel_size = value
    Game.universe.reset
  end

  def grid_width
    canvas_width / pixel_size
  end

  def grid_height
    canvas_height / pixel_size
  end

end
