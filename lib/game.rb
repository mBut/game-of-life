# Game main file
module Game
  class << self
    attr_accessor :config
  end

  # Error throwed if game is misconfigured
  class ConfigurationError < StandardError; end

  # Game configuration helper
  def self.configure
    self.config ||= Config.new
    yield(config) if block_given?
  end

  # Shortcut to universe intance
  def self.universe
    Universe.instance
  end
end

require_relative 'game/config'
require_relative 'game/universe'
require_relative 'game/shape'
require_relative 'game/player'
