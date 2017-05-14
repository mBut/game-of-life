module Game
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

  def self.universe
    Universe.instance
  end
end

require_relative './config'
require_relative './universe'
require_relative './player'
require_relative './util'
