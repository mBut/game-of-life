class Game::Config
  attr_accessor :size, :pixel_size, :shapes, :interval

  def initialize
    @size = [200, 200]
    @pixel_size = 10
    @shapes = {}
    @interval = 1
  end
end
