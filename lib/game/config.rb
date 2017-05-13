module Game
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

  class Config
    attr_accessor :grid_size, :shapes, :interval

    def initialize
      @grid_size = [20, 20]
      @shapes = {}
      @interval = 1
    end
  end
end
