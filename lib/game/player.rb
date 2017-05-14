class Game::Player

  @players = {}

  attr_accessor :color

  def self.find_or_create(id)
    @players[id] ||= self.new
  end

  def self.find(id)
    @players[id]
  end

  def initialize
    generate_random_color!
    self
  end

  private

  def generate_random_color!
    rgb = [rand(255), rand(255), rand(255)]
    self.color = "#" + rgb.map{ |c| c.to_s(16) }.join("")
  end

end
