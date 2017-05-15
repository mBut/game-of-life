module Game
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

  # Shortcut to universe intance
  def self.universe
    Universe.instance
  end
end

require_relative './config'
require_relative './universe'
require_relative './shape'
require_relative './player'
