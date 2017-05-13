class Game::Color

  attr_reader :rgb

  def initialize(r,g,b)
    @rgb = [r,g,b]
  end

  def self.random
    new(rand(255), rand(255), rand(255))
  end

  def as_hex
    "#" + rgb.map{ |c| c.to_s(16) }.join("")
  end
end
