module Game
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= GameConfig.new
    yield(config)
  end

  class GameConfig
    attr_accessor :grid_size, :shapes

    def initialize
      @grid_size = [20, 20]
      @shapes = {}
    end
  end
end
